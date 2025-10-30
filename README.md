# 🫀 MyoAlert Vision

**Sistema inteligente de apoyo diagnóstico para la detección automática del Infarto Agudo de Miocardio con Elevación del Segmento ST (IAMCEST) mediante análisis de señales ECG**

Este repositorio contiene los códigos, modelos, base de datos y documentación desarrollados en el marco del proyecto de tesis **MyoAlert Vision**, presentado en la **Pontificia Universidad Javeriana de Cali (2025)**.

El proyecto integra técnicas de **aprendizaje automático** y **aprendizaje profundo** para el análisis de señales de ECG, con el fin de:

- Estimar la **probabilidad de presencia de IAMCEST**.  
- Identificar la **pared miocárdica afectada** (anterior, inferior, lateral o septal).  
- Proveer una **aplicación web interactiva** para su uso clínico o investigativo.

---

## 📁 Estructura del repositorio

```plaintext
MyoAlert-Vision/
│
├── App/
│   ├── myoalert_vision_app/
│   ├── myoalert_vision_app.zip
│   ├── Manual_de_usuario.pdf
│   └── README.md
│
├── Notebooks/
│   ├── cnn_model.ipynb
│   ├── ml_models.ipynb
│   └── README.md
│
├── LICENSE
└── README.md
🧠 Descripción técnica
🔹 Modelos implementados
Modelos clásicos de ML: LightGBM, XGBoost y RandomForest para la detección de eventos isquémicos y la predicción de la localización anatómica del infarto.

Modelo CNN-1D: Red neuronal convolucional unidimensional para la clasificación binaria (presencia o ausencia de IAMCEST).

Estimación anatómica: Modelos auxiliares para la predicción de la pared afectada (anterior, inferior, lateral o septal).

🔹 Preprocesamiento de las señales
Filtrado pasa banda Butterworth de 4.º orden (0.5–40 Hz).

Suavizado mediante ventana de Hann.

Aplanamiento de las señales con la función flatten.

🧾 Conjunto de datos
Debido a su tamaño, el conjunto de datos se distribuye desde la sección Releases del repositorio.

Archivo	Descripción	Tamaño	SHA-256
Base.de.datos.MyoAlert.Vision.zip	Base de datos completa de señales ECG procesadas (v1.0)	851 MB	795d498675bc0ae84a93da586c11c9a13f82e33934cbaa0befad45d675cfff37
base_de_datos_ecg_2025_v1.csv	Archivo resumen con metadatos y etiquetas reorganizadas de los registros de ECG empleados	2.27 MB	032cb91671ff9ab40ee1e7ec758ce12586c858902f967d913c608735edd37f89

📂 Estructura del dataset
plaintext
Copiar código
Base de datos MyoAlert Vision/
├── ECG_NORMAL/
│   ├── s0001/
│   │   ├── s0001.hea
│   │   └── s0001.dat
│   ├── s0002/
│   │   ├── s0002.hea
│   │   └── s0002.dat
│   └── ...
│
└── ECG_IAMCEST/
    ├── s0001/
    │   ├── s0001.hea
    │   └── s0001.dat
    ├── s0002/
    │   ├── s0002.hea
    │   └── s0002.dat
    └── ...
Cada registro incluye archivos en formato WFDB, compatibles con librerías como wfdb.
Los archivos .hea contienen metadatos clínicos (frecuencia de muestreo, número de derivaciones, duración y datos del paciente), mientras que los archivos .dat almacenan la señal ECG en formato binario.

Nota: El archivo base_de_datos_ecg_2025_v1.csv resume las etiquetas diagnósticas y la trazabilidad de los registros originales de la base MIMIC-IV Waveform Database, reorganizados bajo una nomenclatura unificada para el proyecto MyoAlert Vision.

Para más detalles sobre la estructura y la procedencia de los datos, consulta la sección Releases.

⚠️ Importante: El uso de esta base derivada requiere citar tanto la fuente original (MIMIC-IV WFDB) como el presente proyecto.

📄 Citación
Si utilizas este repositorio, sus modelos o su base de datos en trabajos académicos, por favor cita el proyecto de la siguiente forma:

Referencia en formato IEEE:

W. Obregón Londoño, A. Daza Cerón, C. Torres Valencia y D. F. Ramírez Jiménez,
"MyoAlert Vision: Sistema inteligente de apoyo diagnóstico para la detección automática del Infarto Agudo de Miocardio con Elevación del Segmento ST (IAMCEST) mediante análisis de señales ECG,"
Pontificia Universidad Javeriana de Cali, Colombia, 2025.
