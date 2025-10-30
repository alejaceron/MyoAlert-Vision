# 🫀 MyoAlert Vision

**Sistema inteligente de apoyo diagnóstico para la detección automática del Infarto Agudo de Miocardio con Elevación del Segmento ST (IAMCEST) mediante análisis de señales ECG**

Este repositorio contiene los códigos, modelos, base de datos y documentación desarrollados en el marco del proyecto de tesis **MyoAlert Vision**, presentado en la **Pontificia Universidad Javeriana de Cali (2025)**.

El proyecto integra técnicas de **aprendizaje automático** y **aprendizaje profundo** para el análisis de señales de ECG, con el fin de:
- Estimar la **probabilidad de presencia de IAMCEST**.
- Identificar la **pared miocárdica afectada** (anterior, inferior, lateral o septal).
- Proveer una **Aplicación web interactiva** para su uso clínico o investigativo.

---

## 📁 Estructura del repositorio

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



---

## 🧠 Descripción técnica

### 🔹 Modelos implementados
- **Modelos clásicos de ML:** LightGBM, XGBoost para la deteccion de la presencia de el evento isquemico y para predecir la localización del infarto (anterior, inferior, lateral o septal)..  
- **Modelo CNN-1D:** Red neuronal convolucional unidimensional para verificar si presenta o no la patologia.  
- **Estimación anatómica:** Modelos auxiliares para predecir la localización del infarto (anterior, inferior, lateral o septal).

### 🔹 Preprocesamiento
Nuestro modelo implemento
1. Filtrado pasa banda Butterworth de 4.º orden (0.5–40 Hz).
2. Suavizado de la señal con Ventanas Hann
3. Aplanamiento de las señales con la funcion  flatten

---

## 🧾 Conjunto de datos

Debido a su tamaño, el conjunto de datos se distribuye desde la sección **[Releases](https://github.com/alejaceron/MyoAlert-Vision/releases)** del repositorio.

| Archivo | Descripción | Tamaño | SHA-256 |
|----------|-------------|--------|----------|
| `Base.de.datos.MyoAlert.Vision.zip` | Base de datos completa de señales ECG procesadas (v1.0) | 851 MB | `795d498675bc0ae84a93da586c11c9a13f82e33934cbaa0befad45d675cfff37` |
| `base_de_datos_ecg_2025_v1.csv` | Archivo resumen con metadatos y etiquetas (paciente, diagnóstico, derivaciones, duración, etc.) | 2.27 MB | `032cb91671ff9ab40ee1e7ec758ce12586c858902f967d913c608735edd37f89` |

### 📂 Estructura del dataset

Base de datos MyoAlert Vision/
├── ECG_NORMAL/
│ ├── s0001/
│ │ ├── s0001.hea # Archivo de cabecera (formato WFDB)
│ │ └── s0001.dat # Archivo binario con la señal ECG
│ ├── s0002/
│ │ ├── s0002.hea
│ │ └── s0002.dat
│ └── ...
│
└── ECG_IAMCEST/
├── s0001/
│ ├── s0001.hea
│ └── s0001.dat
├── s0002/
│ ├── s0002.hea
│ └── s0002.dat
└── ...

Cada carpeta contiene registros individuales en formato **WFDB**, compatible con librerías como [`wfdb`](https://wfdb.readthedocs.io/en/latest/)   
Los archivos `.hea` incluyen información de cabecera como:
- Número de derivaciones  
- Frecuencia de muestreo  
- Duración del registro  
- Identificación del sujeto  

Los archivos `.dat` contienen la señal ECG cruda codificada en binario.

> **Nota:** El archivo `base_de_datos_ecg_2025_v1.csv` resume las etiquetas de diagnóstico y los metadatos asociados a cada registro, y puede emplearse para entrenamiento o validación de modelos.

### 📊 Descripción del archivo CSV

El archivo `base_de_datos_ecg_2025_v1.csv` consolida la información reorganizada de los registros provenientes de **MIMIC-IV Waveform Database**, siguiendo una nomenclatura unificada empleada en el proyecto *MyoAlert Vision*.  
Cada fila corresponde a un registro de ECG e incluye:

- `new_id`: Identificador asignado propio del examen (por ejemplo, `s0001`).  
- `id_mimic`: Código del estudio original en la base MIMIC-IV.  
- `diagnóstico`: Etiqueta clínica asignada (`Normal`, `IAMCEST_Anterior`, `IAMCEST_Inferior`, etc.).  
- `duración`: Longitud de la señal en segundos.  
- `fs`: Frecuencia de muestreo.  
- `derivaciones`: Número de canales registrados.  
- `ruta_archivo`: Dirección relativa dentro del dataset comprimido.  

Esta estructura facilita la trazabilidad entre los registros utilizados y su origen clínico, garantizando transparencia en la validación del modelo y reproducibilidad experimental.

> ⚠️ **Importante:** El uso del dataset derivado debe citar la fuente original (MIMIC-IV WFDB) y el proyecto *MyoAlert Vision* según la sección de citación indicada más adelante.

## 📦 Releases del proyecto

Las versiones oficiales del proyecto **MyoAlert Vision** se distribuyen mediante la sección **[Releases de GitHub](https://github.com/alejaceron/MyoAlert-Vision/releases)**.  
Cada release incluye los recursos necesarios para la replicación experimental y el análisis de resultados descritos en la tesis.

### 🔖 Contenido de los releases principales

| Versión | Contenido | Descripción | Fecha de publicación |
|----------|------------|-------------|----------------------|
| **v1.0 – Dataset MyoAlert Vision** | `Base.de.datos.MyoAlert.Vision.zip` <br> `base_de_datos_ecg_2025_v1.csv` | Conjunto completo de señales ECG organizadas por clase (*Normal* / *IAMCEST*), junto con la base de metadatos reestructurada y vinculada a los estudios originales de **MIMIC-IV WFDB**. | Septiembre 2025 |
| **v1.1 – Aplicación Web MyoAlert Vision** | `myoalert_vision_app.zip` <br> `Manual_de_usuario.pdf` | Código fuente y documentación de la aplicación web desarrollada para el soporte diagnóstico basado en los modelos de IA. | Octubre 2025 |

> 📁 Cada release está verificado mediante su hash **SHA-256** para garantizar la integridad de los archivos descargados.

Para descargar una versión específica:
1. Dirígete a la pestaña **[Releases](https://github.com/alejaceron/MyoAlert-Vision/releases)**.  
2. Selecciona la versión deseada.  
3. Descarga los archivos comprimidos correspondientes a tu interés (dataset o aplicación).  


