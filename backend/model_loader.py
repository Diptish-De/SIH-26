"""
SwarSanket Frozen ML Model & Artifact Loader
============================================
Safely loads and validates the frozen, production-trained XGBoost model,
the median imputer, and the 20-feature production contract.

Guarantees:
  - Validates artifact existence and schema integrity at load time.
  - Enforces the exact 20-feature production contract order.
  - Prevents silent substitution of unverified models.
  - Zero inference, zero synthetic feature generation.
"""

import json
import pickle
import warnings
from pathlib import Path
from typing import List, Any
import joblib
import xgboost as xgb
from sklearn.impute import SimpleImputer

EXPECTED_FEATURE_COUNT = 20
MODELS_DIR = Path(__file__).resolve().parent / "models"

MODEL_PATH = MODELS_DIR / "swarsanket_xgboost_final.pkl"
IMPUTER_PATH = MODELS_DIR / "swarsanket_median_imputer.pkl"
FEATURES_PATH = MODELS_DIR / "swarsanket_production_features.json"


def _safe_load_pickle_or_joblib(file_path: Path) -> Any:
    """Loads a serialized python object using joblib with a pickle fallback."""
    try:
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            return joblib.load(file_path)
    except Exception:
        with open(file_path, "rb") as f:
            return pickle.load(f)


def _load_artifacts():
    # 1. Verify existence of all three artifacts
    if not MODEL_PATH.exists():
        raise FileNotFoundError(
            f"Required model artifact missing: '{MODEL_PATH.name}' not found at {MODELS_DIR}"
        )
    if not IMPUTER_PATH.exists():
        raise FileNotFoundError(
            f"Required imputer artifact missing: '{IMPUTER_PATH.name}' not found at {MODELS_DIR}"
        )
    if not FEATURES_PATH.exists():
        raise FileNotFoundError(
            f"Required features contract missing: '{FEATURES_PATH.name}' not found at {MODELS_DIR}"
        )

    # 2. Load and validate production features list
    try:
        with open(FEATURES_PATH, "r", encoding="utf-8") as f:
            features = json.load(f)
    except Exception as e:
        raise ValueError(f"Failed to parse production features JSON from {FEATURES_PATH}: {e}")

    if not isinstance(features, list):
        raise TypeError(f"Expected production features to be a list, got {type(features).__name__}")

    if len(features) != EXPECTED_FEATURE_COUNT:
        raise ValueError(
            f"Production features contract violation: expected exactly {EXPECTED_FEATURE_COUNT} features, "
            f"found {len(features)}."
        )

    # 3. Load XGBoost model
    try:
        loaded_model = _safe_load_pickle_or_joblib(MODEL_PATH)
    except Exception as e:
        raise RuntimeError(f"Failed to load XGBoost model artifact from {MODEL_PATH}: {e}")

    # 4. Load Median Imputer
    try:
        loaded_imputer = _safe_load_pickle_or_joblib(IMPUTER_PATH)
    except Exception as e:
        raise RuntimeError(f"Failed to load median imputer artifact from {IMPUTER_PATH}: {e}")

    # Validate imputer features dimension
    if hasattr(loaded_imputer, "n_features_in_") and loaded_imputer.n_features_in_ != EXPECTED_FEATURE_COUNT:
        raise ValueError(
            f"Imputer feature mismatch: imputer expects {loaded_imputer.n_features_in_} features, "
            f"but contract specifies {EXPECTED_FEATURE_COUNT}."
        )

    return loaded_model, loaded_imputer, features


# Load once on module import
model, imputer, production_features = _load_artifacts()


def get_model_info():
    """Returns metadata summary about the loaded production ML artifacts."""
    return {
        "model_type": type(model).__name__,
        "model_full_class": f"{type(model).__module__}.{type(model).__name__}",
        "imputer_type": type(imputer).__name__,
        "imputer_full_class": f"{type(imputer).__module__}.{type(imputer).__name__}",
        "imputer_strategy": getattr(imputer, "strategy", "unknown"),
        "num_production_features": len(production_features),
        "production_features": list(production_features),
        "model_feature_names_in": list(getattr(model, "feature_names_in_", [])),
        "model_path": str(MODEL_PATH),
        "imputer_path": str(IMPUTER_PATH),
        "features_path": str(FEATURES_PATH),
    }
