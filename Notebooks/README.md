# Desarrollo y Entrenamiento de Modelos

En esta carpeta se encuentran los notebooks utilizados durante el desarrollo y validación del sistema MyoAlert Vision, que abarcan desde el procesamiento de las señales electrocardiográficas hasta la implementación de los modelos de aprendizaje automático.

## Contenido

mld_models_.ipynb: Este notebook contiene el flujo completo de procesamiento y modelado, que incluye:

- Visualización y preprocesamiento de las señales ECG.

- Extracción de características en los dominios temporal, espectral y no lineal (complejo).

- Implementación del modelo XGBoost para la detección del infarto agudo de miocardio (IAM).

- Determinación de la localización anatómica del IAMCEST mediante la combinación entre XGBoost y valores SHAP.

- Entrenamiento del modelo LightGBM para la clasificación del infarto según su localización (anterior, inferior, lateral o septal) junto con técnicas de aumento de datos mediante GNUS y SMOTE.
