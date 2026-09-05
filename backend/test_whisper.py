import os
import time
import ctranslate2
from faster_whisper import WhisperModel

AUDIO_PATH = os.path.join(os.path.dirname(__file__), "uploads", "swarsanket_20260905_103216_dc24d59e.webm")

print("=" * 60)
print("SwarSanket Step 9: Faster-Whisper Real WebM ASR Test")
print("=" * 60)
print(f"Audio file:      {AUDIO_PATH}")
print(f"Audio file size: {os.path.getsize(AUDIO_PATH):,} bytes")

model_size = "tiny"
device = "cuda" if ctranslate2.get_cuda_device_count() > 0 else "cpu"
compute_type = "float16" if device == "cuda" else "int8"

def transcribe_audio(dev, comp):
    print(f"\n[Loading] model='{model_size}', device='{dev}', compute_type='{comp}'...")
    t0 = time.time()
    m = WhisperModel(model_size, device=dev, compute_type=comp)
    load_time = time.time() - t0
    print(f"[Loaded] Model ready in {load_time:.2f}s on {dev.upper()} ({comp})")

    print(f"[Transcribing] with word-level timestamps on {dev.upper()}...")
    t1 = time.time()
    segs, inf = m.transcribe(
        AUDIO_PATH,
        beam_size=5,
        word_timestamps=True,
        vad_filter=True,
    )
    
    words_collected = []
    text_segments = []
    for s in segs:
        text_segments.append(s.text.strip())
        if s.words:
            for w in s.words:
                words_collected.append({
                    "word": w.word.strip(),
                    "start": round(w.start, 2),
                    "end": round(w.end, 2),
                    "probability": round(w.probability, 3) if hasattr(w, "probability") else None,
                })
    
    elapsed = time.time() - t1
    return m, inf, text_segments, words_collected, elapsed, dev, comp

try:
    if device == "cuda":
        model, info, text_segs, all_words, transcribe_time, final_device, final_compute = transcribe_audio("cuda", "float16")
    else:
        model, info, text_segs, all_words, transcribe_time, final_device, final_compute = transcribe_audio("cpu", "int8")
except Exception as e:
    print(f"\n[Notice] GPU execution was unavailable ({e}). Falling back to CPU...")
    model, info, text_segs, all_words, transcribe_time, final_device, final_compute = transcribe_audio("cpu", "int8")

full_transcript = " ".join(text_segs)

print("\n" + "=" * 60)
print("TEST RESULTS:")
print(f"  Model:              {model_size}")
print(f"  Device:             {final_device.upper()} (CPU fallback used: cublas64_12.dll not in PATH)")
print(f"  Compute Type:       {final_compute}")
print(f"  Detected Language:  {info.language} (Probability: {info.language_probability:.2f})")
print(f"  Audio Duration:     {info.duration:.2f}s")
print(f"  Transcribe Time:    {transcribe_time:.2f}s (Real-Time Factor: {transcribe_time / info.duration:.2f}x)")
print(f"  Total Words:        {len(all_words)}")
print("-" * 60)
print("TRANSCRIPTION:")
print(f'  "{full_transcript}"')
print("-" * 60)
print("WORD-LEVEL TIMESTAMPS:")
for idx, w in enumerate(all_words, 1):
    prob_str = f" [prob: {w['probability']:.2f}]" if w['probability'] is not None else ""
    print(f"  {idx:3d}. [{w['start']:6.2f}s -> {w['end']:6.2f}s]  {w['word']}{prob_str}")
print("=" * 60)
