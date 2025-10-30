from flask import Flask, request, jsonify
from flask_cors import CORS
from main import main
import os
import tempfile
import shutil
import wfdb
import io
import base64
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

app = Flask(__name__)
CORS(app)

@app.route("/process_ecg", methods=["POST"])
def process_ecg():
    temp_user_dir = None
    try:
        if 'hea' not in request.files or 'dat' not in request.files:
            return jsonify({"error": "Debes enviar ambos archivos .hea y .dat"}), 400

        hea_file = request.files['hea']
        dat_file = request.files['dat']

        temp_user_dir = tempfile.mkdtemp()
        hea_path = os.path.join(temp_user_dir, hea_file.filename)
        dat_path = os.path.join(temp_user_dir, dat_file.filename)
        hea_file.save(hea_path)
        dat_file.save(dat_path)
        
        result = main(hea_path, dat_path)

        # Generar imagen del ECG original
        record_name = os.path.splitext(os.path.basename(hea_file.filename))[0]
        record = wfdb.rdrecord(os.path.join(temp_user_dir, record_name))
        signals = record.p_signal
        leads = record.sig_name

        fig, axes = plt.subplots(12, 1, figsize=(25, 15), sharex=True)

        for i in range(min(12, signals.shape[1])):
            axes[i].plot(signals[:, i], linewidth=1.2, color='black')
            
            # Etiqueta horizontal al inicio de cada derivación
            axes[i].text(
                0.01, 0.85, leads[i],
                transform=axes[i].transAxes,
                fontsize=15,
                fontweight='bold',
                va='top',
                ha='left'
                
            )

            # Ocultar ejes y bordes
            axes[i].set_xticks([])
            axes[i].set_yticks([])
    
            for spine in axes[i].spines.values():
                spine.set_visible(True)
                spine.set_color('#B0B0B0')  #
                spine.set_linewidth(0.6)
                

        plt.tight_layout(pad=0.3, h_pad=0.1)

        # Guardar en memoria como PNG
        img_buffer = io.BytesIO()
        plt.savefig(img_buffer, format='png', dpi=150, bbox_inches='tight')
        plt.close(fig)
        
        img_buffer.seek(0)
        ecg_image_bytes = img_buffer.read()

        return jsonify({
            "xgboost": result['xgboost'],
            "cnn": result['cnn'],
            "lgb_location": result['lgb_location'],
            "ecg_image": base64.b64encode(ecg_image_bytes).decode('utf-8')  
        })

    finally:
        if temp_user_dir and os.path.exists(temp_user_dir):
            shutil.rmtree(temp_user_dir)


if __name__ == "__main__":
    app.run(debug=True, host="127.0.0.1", port=5000)
