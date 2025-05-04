# Ñawi app

Ñawi actualmente es un proyecto en desarrollo para que docentes del nivel inicial puedan tener una herramienta pedagógica con el cual puedan evaluar de manera formativa a sus estudiantes.

Este proyecto usa algunas características a resaltar por ser algo fuera del framework de Flutter, tales como:
- Drift (Un ORM para Sqlite3): https://drift.simonbinder.eu/setup/
- build_runner (Generador de código que usa Drift y Freezed): Aca cada cambio en las tablas, vistas o el archivo drift_connecion.dart, es necesario aplicar en consola `dart run build_runner build`, para refrescar el contenido de los .g.dart y freezed.dart. (Es obligatorio hacer esto al compilar la aplicación, ya que estos archivos autogenerados no estan versionados en el repositorio)
