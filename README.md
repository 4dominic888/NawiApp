# Ñawi app

Ñawi actualmente es un proyecto en desarrollo para que docentes del nivel inicial puedan tener una herramienta pedagógica con el cual puedan evaluar de manera formativa a sus estudiantes.

Este proyecto usa algunas características a resaltar por ser algo fuera del framework de Flutter, tales como:
- Drift (Un ORM para Sqlite3): https://drift.simonbinder.eu/setup/
- build_runner (Generador de código que usa Drift y Freezed): Aca cada cambio en las tablas, vistas o el archivo drift_connecion.dart, es necesario aplicar en consola `dart run build_runner build`, para refrescar el contenido de los .g.dart y freezed.dart. (Es obligatorio hacer esto al compilar la aplicación, ya que estos archivos autogenerados no estan versionados en el repositorio)

## Backups

Para poder realizar backups de la base de datos, se ha implementado un servicio que usa el algoritmo de cifrado AES-256. Este algoritmo se encuentra en el archivo `backup_crypto_aes_256.dart` y se puede modificar para adaptarse a otros algoritmos de cifrado y hash.

Es necesario definir un archivo `.env` con las siguientes variables:
ENCRYPTION_KEY: Debe tener una longitud de 32 caracteres
ENCRYPTION_IV: Debe tener una longitud de 16 caracteres

```
// Encriptación ejemplo
ENCRYPTION_KEY=12345678901234567890123456789012
ENCRYPTION_IV=12345678901234567890123456789012
```

Para los tests es necesario definir un archivo `.test.env` con las mismas variables.

## Generación de iconos

Para generar los iconos, se ha utilizado el paquete `icons_launcher`, hay un archivo `icons_launcher_dev.yaml` que se puede modificar para personalizar el icono y la plataforma en la que se generarán los iconos. Para generar los iconos, se debe ejecutar `dart run icons_launcher:create --path icons_launcher_dev.yaml`.

En la carpeta `assets/images` se encuentra un archivo `ic_logo.jpeg` que es el icono que se utiliza en la aplicación, es modificable a gusto.