import os
import json
import time
from faster_whisper import WhisperModel
from speech_features import extract_speech_features

AUDIO_FILE = os.path.join(os.path.dirname(__file__), "uploads", "swarsanket_20260905_103216_dc24d59e.webm")

print("=" * 70)
print("SwarSanket Step 10: Speech Feature Extractor Verification")
print("=" * 70)
print(f"Target Audio: {AUDIO_FILE}")

# 1. Run Whisper ASR to get real transcript & timestamps
print("\n[1/3] Transcribing real WebM recording with faster-whisper (tiny)...")
t0 = time.time()
model = WhisperModel("tiny", device="cpu", compute_type="int8")
segments, info = model.transcribe(AUDIO_FILE, word_timestamps=True, vad_filter=True)

words_list = []
text_parts = []
for seg in segments:
    text_parts.append(seg.text.strip())
    if seg.words:
        for w in seg.words:
            words_list.append({
                "word": w.word.strip(),
                "start": float(w.start),
                "end": float(w.end),
                "probability": float(w.probability) if hasattr(w, "probability") else 1.0,
            })

asr_time = time.time() - t0
full_transcript = " ".join(text_parts)
print(f"ASR Completed in {asr_time:.2f}s | Language: {info.language} | Duration: {info.duration:.2f}s")
print(f'Transcript: "{full_transcript}"')
print(f"Total Words Extracted: {len(words_list)}")

# 2. Extract Speech Features
print("\n[2/3] Extracting reproducible speech features from PCM + ASR alignment...")
t1 = time.time()
feature_result = extract_speech_features(
    file_source=AUDIO_FILE,
    transcript=full_transcript,
    words=words_list,
    total_audio_duration=info.duration,
)
extract_time = time.time() - t1
print(f"Feature Extraction Completed in {extract_time * 1000:.2f}ms")

# 3. Print Structured Results
print("\n" + "=" * 70)
print("SWARSANKET REPRODUCIBLE SPEECH FEATURES (Step 10 Output)")
print("=" * 70)

print("\n--- ACOUSTIC & TIMING FEATURES ---")
for k, v in feature_result["acoustic_timing"].items():
    print(f"  {k:35s}: {v}")

print("\n--- TRANSCRIPT & LINGUISTIC FEATURES ---")
for k, v in feature_result["linguistic"].items():
    print(f"  {k:35s}: {v}")

print("\n--- ALL FLATTENED FEATURES DICTIONARY (JSON) ---")
print(json.dumps(feature_result["all_features"], indent=2))

# 4. Safe Edge Case Verification (Empty / Zero-word audio)
print("\n[3/3] Verifying edge case safety (empty recording / no speech)...")
empty_result = extract_speech_features(
    file_source=b"",
    transcript="",
    words=[],
    total_audio_duration=0.0,
)
print("  Empty recording test PASSED without error.")
print(f"  Empty output speech_ratio: {empty_result['all_features']['speech_ratio']}, TTR: {empty_result['all_features']['lexical_diversity_ttr']}")

print("\n" + "=" * 70)
print("STEP 10 VERIFICATION COMPLETED SUCCESSFULLY.")
print("=" * 70)
