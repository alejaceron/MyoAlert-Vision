# Desarrollo y Entrenamiento de Modelos

En esta carpeta se encuentran los notebooks utilizados durante el desarrollo y validación del sistema MyoAlert Vision, que abarcan desde el procesamiento de las señales electrocardiográficas hasta la implementación de los modelos de aprendizaje automático.

## Contenido

ml_models.ipynb: Contiene el flujo de procesamiento y modelado, que incluye:

- Visualización y preprocesamiento de las señales ECG.

- Extracción de características en los dominios temporal, espectral y no lineal (complejo).

- Implementación del modelo XGBoost para la detección del infarto agudo de miocardio con elevación del segmento ST.

- Determinación de la localización anatómica del IAMCEST mediante la combinación entre XGBoost y valores SHAP.

- Entrenamiento del modelo LightGBM para la clasificación del infarto según su localización (anterior, inferior, lateral o septal) junto con técnicas de aumento de datos mediante GNUS y SMOTE.

cnn_model.ipynb: Incluye una parte del procesamiento y entrenamiento del modelo CNN-1D, que comprende:

- Aplanamiento de las señales correspondientes a las 12 derivaciones del registro ECG, generando un vector unidimensional por paciente.

- Implementación de una arquitectura convolucional 1D propia, optimizada para la detección del infarto agudo de miocardio con elevación del segmento ST.
