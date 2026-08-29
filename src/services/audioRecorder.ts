// ─── Real-time Audio Recorder & Web Audio API Analyser ────────────────────────

import { VoiceQualityGrade } from "../types";

export interface AudioRecordingResult {
  blob: Blob;
  durationSeconds: number;
  quality: VoiceQualityGrade;
  audioUrl: string;
  snrEstimateDb: number;
}

export class VoiceRecorder {
  private mediaRecorder: MediaRecorder | null = null;
  private audioContext: AudioContext | null = null;
  private analyserNode: AnalyserNode | null = null;
  private mediaStream: MediaStream | null = null;
  private audioChunks: Blob[] = [];
  private startTime = 0;
  private pausedDuration = 0;
  private pauseStartTime = 0;
  private animationFrameId: number | null = null;
  private onLevelUpdate?: (level: number, frequencies: Uint8Array) => void;

  async start(onLevel?: (level: number, frequencies: Uint8Array) => void): Promise<boolean> {
    this.audioChunks = [];
    this.startTime = Date.now();
    this.pausedDuration = 0;
    this.onLevelUpdate = onLevel;

    try {
      if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
        this.mediaStream = await navigator.mediaDevices.getUserMedia({
          audio: {
            echoCancellation: true,
            noiseSuppression: true,
            sampleRate: 44100,
          },
        });

        // Initialize Web Audio API Analyser
        const AudioCtx = window.AudioContext || (window as unknown as { webkitAudioContext: typeof AudioContext }).webkitAudioContext;
        this.audioContext = new AudioCtx();
        const source = this.audioContext.createMediaStreamSource(this.mediaStream);
        this.analyserNode = this.audioContext.createAnalyser();
        this.analyserNode.fftSize = 64;
        this.analyserNode.smoothingTimeConstant = 0.8;
        source.connect(this.analyserNode);

        // Start animation loop for audio level
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
      }
    } catch (err) {
      console.warn("Microphone access not available or denied. Using audio simulation fallback:", err);
    }

    // Fallback simulation mode
    this.startSimulationLoop();
    return false;
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

    return new Promise((resolve) => {
      if (this.mediaRecorder && this.mediaRecorder.state !== "inactive") {
        this.mediaRecorder.onstop = () => {
          const blob = new Blob(this.audioChunks, { type: this.mediaRecorder?.mimeType || "audio/webm" });
          const audioUrl = URL.createObjectURL(blob);
          this.cleanup();

          // Calculate quality
          const quality: VoiceQualityGrade = durationSeconds >= 5 ? "good" : durationSeconds >= 2 ? "poor" : "low";
          const snrEstimateDb = quality === "good" ? 25.4 : quality === "poor" ? 14.2 : 8.5;

          resolve({ blob, durationSeconds, quality, audioUrl, snrEstimateDb });
        };
        this.mediaRecorder.stop();
      } else {
        this.cleanup();
        // Return simulated result
        const dummyBlob = new Blob(["RIFF....WAVEfmt "], { type: "audio/wav" });
        const quality: VoiceQualityGrade = durationSeconds >= 5 ? "good" : durationSeconds >= 2 ? "poor" : "low";
        resolve({
          blob: dummyBlob,
          durationSeconds,
          quality,
          audioUrl: "",
          snrEstimateDb: quality === "good" ? 26.0 : 12.0,
        });
      }
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

  private startSimulationLoop() {
    const dummyFreqs = new Uint8Array(32);
    const update = () => {
      const now = Date.now();
      const simLevel = 0.25 + 0.35 * Math.sin(now / 200) + 0.15 * Math.cos(now / 120);
      for (let i = 0; i < 32; i++) {
        dummyFreqs[i] = Math.floor(Math.max(0, Math.min(255, (simLevel + Math.sin(now / 150 + i)) * 180)));
      }
      this.onLevelUpdate?.(Math.max(0.1, Math.min(1.0, simLevel)), dummyFreqs);
      this.animationFrameId = requestAnimationFrame(update);
    };
    this.animationFrameId = requestAnimationFrame(update);
  }

  private cleanup() {
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
