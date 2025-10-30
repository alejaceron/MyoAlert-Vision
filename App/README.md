# MyoAlert Vision — Desarrollo de Aplicación Web

En este repositorio se encuentra el desarrollo completo de MyoAlert Vision, una aplicación web orientada al apoyo diagnóstico del Infarto Agudo de Miocardio con Elevación del Segmento ST (IAMCEST) mediante el análisis automatizado de señales de ECG de 12 derivaciones.

## Contenido

- Manual de usuario: documento que describe el funcionamiento general de la aplicación, la navegación por sus módulos y las funcionalidades disponibles para el usuario.

- Carpeta de ejecución (myoalert_signal/): contiene todos los archivos necesarios para el despliegue del sistema, incluyendo el backend (Python/Flask) y el frontend desarrollado en Flutter Web.

- Archivo ZIP: incluye el paquete completo del proyecto, con el código fuente y los recursos necesarios para su ejecución o despliegue local.

## Ejecución de la aplicación

Para ejecutar la aplicación localmente, asegúrate de tener instaladas las dependencias correspondientes a Python, Flutter y Node.js.
Luego, desde la carpeta raíz del proyecto, utiliza el siguiente comando:

```bash
npx concurrently "python myoalert_signal/app.py" "flutter run -d chrome"
```

Este comando ejecuta de forma simultánea:

- El backend en Python, que gestiona el procesamiento de las señales ECG y la comunicación con los modelos de aprendizaje automático.

- El frontend en Flutter Web, encargado de la interfaz de usuario y la visualización de resultados.
