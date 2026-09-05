import numpy as np
import pandas as pd
from model_loader import model, imputer, production_features

aligned_live = {
    "CTP_noun_ratio": 0.117647,
    "CTP_verb_ratio": 0.205882,
    "CTP_adv_ratio": 0.117647,
    "CTP_Pronouns_ratio": 0.147059,
    "CTP_noun to verb": 0.571429,
    "CTP_Word Rate(-/s)": 2.768730,
    "CTP_unique_IU_efficiency": 0.411765,
    "CTP_ keyword_TTR": 0.933333,
}

raw_vector = {col: aligned_live.get(col, np.nan) for col in production_features}
df_raw = pd.DataFrame([raw_vector], columns=production_features)
imputed_array = imputer.transform(df_raw)
df_imputed = pd.DataFrame(imputed_array, columns=production_features)

pred = int(model.predict(df_imputed)[0])
probs = model.predict_proba(df_imputed)[0]
prob_class_1 = float(probs[1])

print("Model Prediction with Aligned 96E Features:")
print(f"  Predicted Class: {pred}")
print(f"  Class 1 Prob:    {prob_class_1:.6f} ({prob_class_1*100:.2f}%)")
print(f"  Confidence:      {abs(prob_class_1 - 0.5)*2*100:.2f}%")
