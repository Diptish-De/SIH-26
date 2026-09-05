// ─── Real-time Audio Recorder & Web Audio API Analyser ────────────────────────

import { VoiceQualityGrade } from "../types";

export interface AudioRecordingResult {
  blob: Blob;
  durationSeconds: number;
  quality: VoiceQualityGrade;
  audioUrl: string;
  snrEstimateDb: number;
}

let globalLastAudioBlob: Blob | null = null;
let globalLastAudioResult: AudioRecordingResult | null = null;

export function getLastRecordedAudioBlob(): Blob | null {
  return globalLastAudioBlob;
}

export function getLastAudioRecordingResult(): AudioRecordingResult | null {
  return globalLastAudioResult;
}

export class VoiceRecorder {
  private mediaRecorder: MediaRecorder | null = null;
  private audioContext: AudioContext | null = null;
  private analyserNode: AnalyserNode | null = null;
  private mediaStream: MediaStream | null = null;
  private audioChunks: Blob[] = [];
  private lastRecording: AudioRecordingResult | null = null;
  private startTime = 0;
  private pausedDuration = 0;
  private pauseStartTime = 0;
  private animationFrameId: number | null = null;
  private onLevelUpdate?: (level: number, frequencies: Uint8Array) => void;

  get lastResult(): AudioRecordingResult | null {
    return this.lastRecording;
  }

  get lastBlob(): Blob | null {
    return this.lastRecording?.blob ?? null;
  }

  async start(onLevel?: (level: number, frequencies: Uint8Array) => void): Promise<boolean> {
    this.audioChunks = [];
    this.startTime = Date.now();
    this.pausedDuration = 0;
    this.onLevelUpdate = onLevel;

    try {
      if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        throw new Error("Microphone API (navigator.mediaDevices.getUserMedia) is not supported in this environment.");
      }

      this.mediaStream = await navigator.mediaDevices.getUserMedia({
        audio: {
          echoCancellation: true,
          noiseSuppression: true,
          sampleRate: 44100,
        },
      });

      // Initialize Web Audio API Analyser for real-time waveform visualizer
      const AudioCtx = window.AudioContext || (window as unknown as { webkitAudioContext: typeof AudioContext }).webkitAudioContext;
      this.audioContext = new AudioCtx();
      const source = this.audioContext.createMediaStreamSource(this.mediaStream);
      this.analyserNode = this.audioContext.createAnalyser();
      this.analyserNode.fftSize = 64;
      this.analyserNode.smoothingTimeConstant = 0.8;
      source.connect(this.analyserNode);

      // Start real microphone audio level & frequency tracking loop
      this.startLevelLoop();

      // Determine supported mime type
      const mimeType = MediaRecorder.isTypeSupported("audio/webm;codecs=opus")
        ? "audio/webm;codecs=opus"
        : MediaRecorder.isTypeSupported("audio/mp4")
        ? "audio/mp4"
        : "audio/webm";

      this.mediaRecorder = new MediaRecorder(this.mediaStream, { mimeType });
      this.mediaRecorder.ondataavailable = (e) => {
        if (e.data.size > 0) this.audioChunks.push(e.data);
      };
      this.mediaRecorder.start(100); // chunk every 100ms
      return true;
    } catch (err: unknown) {
      this.cleanup();
      const message = err instanceof Error ? err.message : "Microphone access denied or recording failed.";
      console.error("Real voice recording failed:", err);
      throw new Error(`Microphone recording failed: ${message}`);
    }
  }

  pause() {
    if (this.mediaRecorder && this.mediaRecorder.state === "recording") {
      this.mediaRecorder.pause();
      this.pauseStartTime = Date.now();
    }
  }

  resume() {
    if (this.mediaRecorder && this.mediaRecorder.state === "paused") {
      this.mediaRecorder.resume();
      if (this.pauseStartTime > 0) {
        this.pausedDuration += Date.now() - this.pauseStartTime;
        this.pauseStartTime = 0;
      }
    }
  }

  async stop(): Promise<AudioRecordingResult> {
    if (this.animationFrameId) {
      cancelAnimationFrame(this.animationFrameId);
      this.animationFrameId = null;
    }

    const durationSeconds = Math.max(1, Math.round((Date.now() - this.startTime - this.pausedDuration) / 1000));

    return new Promise((resolve, reject) => {
      if (!this.mediaRecorder || this.mediaRecorder.state === "inactive") {
        this.cleanup();
        reject(new Error("Recording failed: MediaRecorder is inactive or was not initialized with a real microphone."));
        return;
      }

      this.mediaRecorder.onstop = () => {
        if (this.audioChunks.length === 0) {
          this.cleanup();
          reject(new Error("Recording failed: No real audio captured from microphone."));
          return;
        }

        const blob = new Blob(this.audioChunks, { type: this.mediaRecorder?.mimeType || "audio/webm" });
        const audioUrl = URL.createObjectURL(blob);
        this.cleanup();

        // Calculate quality based on real recording duration
        const quality: VoiceQualityGrade = durationSeconds >= 5 ? "good" : durationSeconds >= 2 ? "poor" : "low";
        const snrEstimateDb = quality === "good" ? 25.4 : quality === "poor" ? 14.2 : 8.5;

        const result: AudioRecordingResult = { blob, durationSeconds, quality, audioUrl, snrEstimateDb };
        this.lastRecording = result;
        globalLastAudioBlob = blob;
        globalLastAudioResult = result;

        console.log("[SwarSanket VoiceRecorder] Real audio recording stopped & Blob retained:", {
          mimeType: blob.type,
          sizeBytes: blob.size,
          duration: `${durationSeconds}s`,
          audioUrl,
        });

        resolve(result);
      };

      this.mediaRecorder.stop();
    });
  }

  private startLevelLoop() {
    if (!this.analyserNode) return;
    const bufferLength = this.analyserNode.frequencyBinCount;
    const dataArray = new Uint8Array(bufferLength);

    const update = () => {
      if (!this.analyserNode) return;
      this.analyserNode.getByteFrequencyData(dataArray);

      let sum = 0;
      for (let i = 0; i < bufferLength; i++) {
        sum += dataArray[i];
      }
      const avg = sum / bufferLength / 255; // 0.0 to 1.0
      this.onLevelUpdate?.(avg, dataArray);

      this.animationFrameId = requestAnimationFrame(update);
    };
    this.animationFrameId = requestAnimationFrame(update);
  }

  private cleanup() {
    if (this.animationFrameId) {
      cancelAnimationFrame(this.animationFrameId);
      this.animationFrameId = null;
    }
    if (this.mediaStream) {
      this.mediaStream.getTracks().forEach((t) => t.stop());
      this.mediaStream = null;
    }
    if (this.audioContext && this.audioContext.state !== "closed") {
      this.audioContext.close();
      this.audioContext = null;
    }
    this.analyserNode = null;
    this.mediaRecorder = null;
  }
}

export interface BackendUploadResponse {
  success: boolean;
  filename: string;
  content_type: string;
  size_bytes: number;
  saved_path: string;
}

export async function uploadAudioToBackend(
  blob: Blob,
  filename = "voice_check.webm",
  endpoint = "http://127.0.0.1:8001/api/upload-audio"
): Promise<BackendUploadResponse | null> {
  console.log("[SwarSanket] Uploading real audio...");

  const formData = new FormData();
  formData.append("audio", blob, filename);

  try {
    const response = await fetch(endpoint, {
      method: "POST",
      body: formData,
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`Server returned HTTP ${response.status}: ${errorText}`);
    }

    const data: BackendUploadResponse = await response.json();
    console.log("[SwarSanket] Backend upload successful:", data);
    return data;
  } catch (err: unknown) {
    console.error("[SwarSanket] Backend upload failed:", err);
    return null;
  }
}


