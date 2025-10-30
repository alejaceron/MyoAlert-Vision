import joblib
import sys
import os
import numpy as np
import warnings
import struct
import tempfile
import json
from tensorflow.keras.models import load_model
from normalize_lead_names import normalize_lead_names
from preprocessing import preprocessing, filtered_signals_global, signal_names_global
from flatten_signal import flatten_signal
from first_feature_extraction import extract_features_all

# Ocultar warnings
warnings.filterwarnings("ignore")

# Cargar modelos
current_dir = os.path.dirname(os.path.abspath(__file__))
xgb_model = joblib.load(os.path.join(current_dir, "xgb_model.pkl"))
lgb_model = joblib.load(os.path.join(current_dir, "lgb_model.pkl"))
cnn_path = os.path.join(current_dir, "final_model_CNN.h5")
cnn_model = load_model(cnn_path)


def save_preprocessed_ecg(temp_dir, signals, signal_names, fs=500):

    num_signals = len(signals)
    num_samples = len(signals[0])

    dat_file = os.path.join(temp_dir, "preprocessed.dat")
    hea_file = os.path.join(temp_dir, "preprocessed.hea")

    # Guardar .dat
    with open(dat_file, "wb") as f:
        for i in range(num_samples):
            for ch in range(num_signals):
                val = int(signals[ch][i])
                f.write(struct.pack('<h', val))

    # Guardar .hea
    with open(hea_file, "w") as f:
        f.write(f"preprocessed {num_signals} 1 {num_samples} {fs}\n")
        for name in signal_names:
            f.write(f"{dat_file} 16 200 0 0 {name}\n")

    return hea_file, dat_file


def main(hea_file, dat_file):
    global filtered_signals_global, signal_names_global

    # Crear directorio temporal único
    temp_dir = tempfile.mkdtemp()

    # Normalizar nombres de derivaciones
    hea_file_normalized = normalize_lead_names(hea_file)

    # Preprocesamiento
    filtered_signals_global, signal_names_global = preprocessing(hea_file_normalized, dat_file)
    print("Preprocesamiento completo")

    # Concatenación y extracción de features
    X_cnn = flatten_signal(filtered_signals_global, signal_names_global)
    features_df = extract_features_all(filtered_signals_global, signal_names_global)

    # Reordenar columnas según XGBoost
    expected_features = xgb_model.get_booster().feature_names
    features_df = features_df[expected_features]

    # Predicciones
    prob_infarct = xgb_model.predict_proba(features_df)[0][1]
    pred_infarct = int(prob_infarct >= 0.8)

    X_cnn_exp = np.expand_dims(X_cnn, axis=(0, -1))
    prob_infarct_2 = cnn_model.predict(X_cnn_exp)[0][0]
    pred_infarct_2 = int(prob_infarct_2 >= 0.8)

    pred_location = lgb_model.predict(features_df)[0] if (pred_infarct or pred_infarct_2) else "Ninguna"

    print(f"Probabilidad XGBoost: {prob_infarct*100:.2f}%")
    print(f"Probabilidad CNN: {prob_infarct_2*100:.2f}%")
    print(f"Localización: {pred_location}")

    # Guardar señales filtradas
    filtered_hea, filtered_dat = save_preprocessed_ecg(temp_dir, filtered_signals_global, signal_names_global)

    # Retornar resultados
    return {
        "xgboost": float(prob_infarct),
        "cnn": float(prob_infarct_2),
        "lgb_location": pred_location,
        "hea_file": filtered_hea,
        "dat_file": filtered_dat,
        "tmp_dir": temp_dir 
    }


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print(json.dumps({"error": "Debes proporcionar archivo .hea y .dat"}))
        sys.exit(1)

    hea_file = sys.argv[1]
    dat_file = sys.argv[2]

    if not os.path.exists(hea_file) or not os.path.exists(dat_file):
        print(json.dumps({"error": "Uno o ambos archivos no existen"}))
        sys.exit(1)

    result = main(hea_file, dat_file)
    print(json.dumps(result))
