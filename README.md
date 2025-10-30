# MyoAlert Vision

**Sistema inteligente de apoyo diagnóstico para la detección automática del Infarto Agudo de Miocardio con Elevación del Segmento ST (IAMCEST) mediante análisis de señales ECG**

Este repositorio contiene los códigos, modelos, base de datos y documentación desarrollados en el marco del proyecto de tesis **MyoAlert Vision**, presentado en la **Pontificia Universidad Javeriana de Cali (2025)**.

El proyecto integra técnicas de aprendizaje automático y aprendizaje profundo para el análisis de señales de ECG, con el fin de:

- Estimar la probabilidad de presencia de IAMCEST.  
- Identificar la pared miocárdica afectada (anterior, inferior, lateral o septal).  
- Proveer una aplicación web interactiva para su uso clínico o investigativo.

---

## Contenido del repositorio

- `App/` – Contiene la aplicación web **MyoAlert Vision**, junto con su manual de usuario y archivos de ejecución.  
- `Notebooks/` – Incluye los cuadernos de entrenamiento y evaluación de modelos de aprendizaje automático y profundo.  
- `LICENSE` – Licencia MIT del proyecto.  
- `README.md` – Documento descriptivo del repositorio.

Estructura general:

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
Modelos implementados

Modelos clásicos de Machine Learning: LightGBM, XGBoost y RandomForest, empleados para la detección de eventos isquémicos y la predicción de la localización anatómica del infarto.

Modelo CNN-1D: Red neuronal convolucional unidimensional para la clasificación binaria (presencia o ausencia de IAMCEST).

Estimación anatómica: Modelos auxiliares para la predicción de la pared afectada (anterior, inferior, lateral o septal).

Preprocesamiento de las señales

Cada modelo utiliza un proceso estandarizado de preparación de los datos de ECG, que incluye las siguientes etapas:

Filtrado pasa banda Butterworth de cuarto orden (0.5–40 Hz).

Suavizado de la señal mediante ventana de Hann.

Aplanamiento de las señales mediante la función flatten para su compatibilidad con los modelos.

Conjunto de datos

Debido a su tamaño, el conjunto de datos se distribuye desde la sección Releases
 del repositorio.

Archivo	Descripción	Tamaño	SHA-256
Base.de.datos.MyoAlert.Vision.zip	Base de datos completa de señales ECG procesadas (v1.0)	851 MB	795d498675bc0ae84a93da586c11c9a13f82e33934cbaa0befad45d675cfff37
base_de_datos_ecg_2025_v1.csv	Archivo resumen con metadatos y etiquetas reorganizadas de los registros de ECG empleados	2.27 MB	032cb91671ff9ab40ee1e7ec758ce12586c858902f967d913c608735edd37f89
Estructura del conjunto de datos
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


Cada registro incluye archivos en formato WFDB, compatibles con librerías como wfdb
.
Los archivos .hea contienen metadatos clínicos (frecuencia de muestreo, número de derivaciones, duración y datos del paciente), mientras que los archivos .dat almacenan la señal ECG en formato binario.

El archivo base_de_datos_ecg_2025_v1.csv resume las etiquetas diagnósticas y la trazabilidad de los registros originales de la base MIMIC-IV Waveform Database, reorganizados bajo una nomenclatura unificada para el proyecto MyoAlert Vision.

Licencia

Este proyecto está bajo la Licencia MIT, lo que permite su uso, distribución y modificación con fines académicos y de investigación, siempre que se otorgue el crédito correspondiente a los autores originales.

Consulta el archivo LICENSE
 para más detalles.

Citación

Si utilizas este repositorio, sus modelos o su base de datos en trabajos académicos, por favor cita el proyecto de la siguiente forma:

Referencia en formato IEEE:

J. A. Daza Ceron y W. F. Obregón Londoño,
“MyoAlert Vision: Sistema inteligente de apoyo diagnóstico para la detección automática del Infarto Agudo de Miocardio con Elevación del Segmento ST (IAMCEST) mediante análisis de señales ECG,”
Pontificia Universidad Javeriana de Cali, Colombia, 2025.

Director: Dr. Cristian Alejandro Torres Valencia
Codirectora: MSc. Valentina Corchuelo Guzmán

© 2025 MyoAlert Vision — Pontificia Universidad Javeriana de Cali.
