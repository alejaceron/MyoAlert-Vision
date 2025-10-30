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

##  Base de datos MyoAlert Vision

La base de datos **MyoAlert Vision** fue estructurada a partir de registros provenientes de la **MIMIC-IV Waveform Database**, reorganizados bajo una nueva nomenclatura que estandariza la identificación de cada examen.  
Esta base contiene dos grupos principales:

- `ECG_NORMAL/` → Registros sin alteraciones cardíacas.  
- `ECG_IAMCEST/` → Registros correspondientes a pacientes con diagnóstico confirmado de Infarto Agudo de Miocardio con Elevación del Segmento ST.  

El archivo `base_de_datos_ecg_2025_v1.csv` actúa como índice general del dataset, relacionando cada nuevo identificador con su código original en MIMIC-IV, diagnóstico clínico, duración de señal y metadatos técnicos.

 La versión más reciente del dataset y su documentación detallada se encuentra en la sección de **[Releases](../../releases)** del repositorio.

---

##  Licencia

Este proyecto está distribuido bajo la licencia **MIT**, lo que permite su uso académico, investigativo y de libre acceso, siempre que se otorgue el crédito correspondiente a los autores y a la **Pontificia Universidad Javeriana de Cali**.

---
## Referencia y citación

Si utilizas este proyecto, su base de datos o cualquiera de los modelos desarrollados, por favor realiza la citación correspondiente para otorgar crédito académico a los autores y directores del trabajo.

**Referencia (formato APA):**

Daza Cerón, J. A., Obregón Londoño, W. F., Torres, C., & Corchuelo, V. (2025).  
*MyoAlert Vision: sistema inteligente de apoyo diagnóstico para la identificación automática del infarto agudo de miocardio con elevación del segmento ST mediante análisis electrocardiográfico.*  
Pontificia Universidad Javeriana Cali — Facultad de Ingeniería, Programa de Ingeniería Biomédica.

**Autores:**  
- Julieth Alejandra Daza Cerón  
- William Felipe Obregón Londoño  

**Dirección académica:**  
- Ing. Cristian Torres, M.Sc.  
- Ing. Valentina Corchuelo, Ph.D.  

---

### Cita en formato BibTeX

Si deseas incluir esta referencia en un documento LaTeX o gestor bibliográfico, puedes copiar el siguiente bloque:

```bibtex
@thesis{Daza2025MyoAlertVision,
  title        = {MyoAlert Vision: sistema inteligente de apoyo diagnóstico para la identificación automática del infarto agudo de miocardio con elevación del segmento ST mediante análisis electrocardiográfico},
  author       = {Daza Cerón, Julieth Alejandra and Obregón Londoño, William Felipe and Torres, Cristian and Corchuelo, Valentina},
  year         = {2025},
  institution  = {Pontificia Universidad Javeriana Cali},
  type         = {Trabajo de grado},
  school       = {Facultad de Ingeniería, Programa de Ingeniería Biomédica},
  address      = {Cali, Colombia}
}
  

---

**© 2025 MyoAlert Vision Project — Pontificia Universidad Javeriana Cali**
