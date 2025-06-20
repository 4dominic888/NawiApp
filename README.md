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

Adicionalmente, se ha creado un archivo `ic_logo_splash.png` que es el icono que se utiliza en la pantalla de inicio de la aplicación. Para generar el icono, se debe ejecutar `dart run flutter_native_splash:create`.

## Análisis con SonarQube

Se necesitará crear un archivo `sonar-project.properties` en la raíz del proyecto con el siguiente contenido:
PD: Esta configuración variará dependiendo de la instalación de SonarQube en tu equipo.

```
# Project identification, either hardcode it or use Environment variables
sonar.projectKey=NawiApp
sonar.projectName=NawiApp
sonar.login=tucodigo-generadoporsonarqube

# The host URL
sonar.host.url=http://tu-url-de-sonarqube

# Source code location.
# Path is relative to the sonar-project.properties file. Defaults to .
# Use commas to specify more than one folder.
sonar.sources=lib
sonar.tests=test

# Encoding of the source code. Default is default system encoding.
sonar.sourceEncoding=UTF-8

# exclude generated files
sonar.exclusions=test/**/*_test.mocks.dart,lib/**/*.g.dart
```
## Generación del apk

Para generar el apk, se debe ejecutar `flutter build apk --release --no-tree-shake-icons --obfuscate --split-debug-info=build/app/outputs/symbols`.

`--no-tree-shake-icons` se utiliza para evitar errores en una funcionalidad de iconos dinamicos sin el uso de const.
`--obfuscate --split-debug-info=build/app/outputs/symbols` se utiliza para evitar que el código fuente sea visible en el apk. Se puede omitir para pruebas, pero es recomendable hacer pruebas en un dispositivo real, para asegurar de que el código ofuscado no cause problemas de funcionalidad.

> Nota: Esta aplicación aun no esta lista para lanzarse en la Play Store, por lo que no se puede generar el appbundle.