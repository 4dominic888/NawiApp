# Ñawi app

Ñawi actualmente es un proyecto en desarrollo para que docentes del nivel inicial puedan tener una herramienta pedagógica con el cual puedan evaluar de manera formativa a sus estudiantes.

Este proyecto usa algunas herramientas externas, tales como:
- Drift (Un ORM para Sqlite3): https://drift.simonbinder.eu/setup/
- build_runner (Generador de código que usa Drift): Aca cada cambio en las tablas, vistas o el archivo database_connecion.dart, es necesario aplicar en consola `flutter pub run build_runner build`, para refrescar el contenido de los .g.dart.
