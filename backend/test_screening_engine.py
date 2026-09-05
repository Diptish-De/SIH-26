import os
import sys
import json
from pathlib import Path

# Ensure backend directory is in python path
BACKEND_DIR = Path(__file__).resolve().parent
if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))

from model_loader import production_features
from screening_engine import (
    run_screening_pipeline,
    VALIDATED_LIVE_FEATURES,
    UNRESOLVED_IMPUTED_FEATURES,
)

AUDIO_DIR = BACKEND_DIR / "uploads"
audio_files = list(AUDIO_DIR.glob("*.webm")) + list(AUDIO_DIR.glob("*.m4a")) + list(AUDIO_DIR.glob("*.wav"))

if not audio_files:
    raise FileNotFoundError(f"No audio files found in {AUDIO_DIR} to run the screening engine test.")

test_audio_path = str(audio_files[0])

print("=" * 75)
print("SwarSanket STEP 96G-D-FIX: Live Screening Engine Pipeline Verification")
print("=" * 75)
print(f"Target Audio File: {test_audio_path}")

# Run 1: Full pipeline execution
print("\n[1/4] Running live screening engine on target audio (Pass 1)...")
result_pass1 = run_screening_pipeline(test_audio_path)

if not result_pass1["success"]:
    print(f"ERROR in screening pipeline: {result_pass1.get('error')}")
    sys.exit(1)

# Verification checks
print("\n[2/4] Validating production contract integrity & feature partitioning...")

transcript = result_pass1["transcript"]
print(f"  Transcript:            \"{transcript}\"")
assert len(transcript) > 0, "Transcript is empty!"

prod_feats = result_pass1["production_features"]
assert len(prod_feats) == 20, f"Expected 20 production features, got {len(prod_feats)}"
assert list(prod_feats.keys()) == production_features, "Feature order does not match production contract!"

live_count = sum(1 for v in prod_feats.values() if v["is_live_extracted"])
imputed_count = sum(1 for v in prod_feats.values() if not v["is_live_extracted"])

print(f"  Total Prod Features:   {len(prod_feats)}")
print(f"  Live Extracted:        {live_count} (Expected: 8)")
print(f"  Median Imputed:        {imputed_count} (Expected: 12)")

assert live_count == 8, f"Expected 8 live features, found {live_count}"
assert imputed_count == 12, f"Expected 12 imputed features, found {imputed_count}"

# Verify exactly the 8 validated features have raw values
for feat in VALIDATED_LIVE_FEATURES:
    assert prod_feats[feat]["raw_value"] is not None, f"Live feature '{feat}' has None raw_value!"

for feat in UNRESOLVED_IMPUTED_FEATURES:
    assert prod_feats[feat]["raw_value"] is None, f"Unresolved feature '{feat}' should have None raw_value!"
    assert prod_feats[feat]["imputed_value"] is not None, f"Imputed feature '{feat}' missing imputed_value!"

screening = result_pass1["screening"]
predicted_class = screening["predicted_class"]
prob = screening["probability"]
prob_pct = screening["probability_percent"]
conf_pct = screening["technical_confidence_percent"]
status = screening["status"]

print(f"  Predicted Class:       {predicted_class} ({status})")
print(f"  Probability:           {prob} ({prob_pct}%)")
print(f"  Technical Confidence:  {conf_pct}% (Calculated as |prob - 0.5| * 2)")
print(f"  Interpretation:        \"{screening['interpretation']}\"")

assert predicted_class in (0, 1), f"Invalid predicted class: {predicted_class}"
assert 0.0 <= prob <= 1.0, f"Invalid probability: {prob}"

# Run 2: Determinism check
print("\n[3/4] Verifying pipeline determinism across consecutive passes (Pass 2)...")
result_pass2 = run_screening_pipeline(test_audio_path)
prob2 = result_pass2["screening"]["probability"]

prob_diff = abs(prob - prob2)
print(f"  Pass 1 Probability:    {prob:.6f}")
print(f"  Pass 2 Probability:    {prob2:.6f}")
print(f"  Absolute Delta:        {prob_diff:.8f}")

assert prob_diff < 1e-6, f"Pipeline output is non-deterministic! Delta={prob_diff}"
print("  [PASS] Output is strictly deterministic within floating-point tolerance.")

# Display clean summary table
print("\n[4/4] Extracted 20-Feature Production Table:")
print("-" * 75)
print(f"{'#':<3} {'Feature Name':<35} {'Raw Live':<12} {'Imputed Val':<12} {'Type'}")
print("-" * 75)
for idx, (fname, fmeta) in enumerate(prod_feats.items(), 1):
    raw_str = f"{fmeta['raw_value']:.6f}" if fmeta['raw_value'] is not None else "NaN (unres)"
    imp_str = f"{fmeta['imputed_value']:.6f}"
    ftype = "LIVE" if fmeta["is_live_extracted"] else "MEDIAN_IMPUTED"
    print(f"{idx:<3} {fname:<35} {raw_str:<12} {imp_str:<12} {ftype}")

print("=" * 75)
print("STEP 96G-D-FIX SCREENING ENGINE PIPELINE: ALL CHECKS PASSED.")
print("=" * 75)
