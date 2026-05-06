# Gimnasio - Taller 4: Structs, Mapas y Manejo de Archivos en Elixir

## Descripción
**ES IMPORTANTE MENCIONAR QUE ES NECESARIO USAR COMMAND PROMPT EN LUGAR DE POWERSHELL EN VISUAL STUDIO**

Sistema de gestión de socios para un gimnasio implementado en Elixir. Permite registrar socios, inscribirlos en clases y persistir la información en un archivo CSV.

## Estructura del proyecto

```
gimnasio/
├── lib/
│   ├── gimnasio.ex          # Módulo principal y punto de entrada
│   ├── application.ex       # Configuración OTP Application
│   ├── socio.ex             # Struct Socio + validaciones
│   ├── logica.ex            # Lógica de negocio (Gimnasio)
│   ├── gestion_archivos.ex  # Lectura/escritura CSV
│   └── menu.ex              # Interfaz de consola
├── mix.exs
└── socios.csv               # Generado automáticamente al ejecutar
```

## Cómo ejecutar

```bash
# Instalar dependencias (no hay externas, pero Mix las necesita)
mix deps.get

# Compilar
mix compile

# Ejecutar el menú interactivo
mix run -e "Gimnasio.main()"
```

## Funcionalidades

- Crear y eliminar socios (con validaciones)
- Inscribir / desinscribir socios en clases
- Buscar socio por cédula
- Listar todos los socios
- Listar socios inscritos en una clase específica
- Ver todas las clases de un socio
- Ver estadísticas del gimnasio
- Persistencia automática en `socios.csv`

## Aprendizajes

- Uso de `defstruct` con `@enforce_keys` para structs obligatorios.
- Manejo de errores con `{:ok, resultado}` / `{:error, motivo}` y `with`.
- Operaciones con `Map` como estructura de datos principal.
- Lectura y escritura de archivos CSV con `File.read/1` y `File.write/2`.
- Organización de código en módulos con responsabilidades separadas.
- Uso de `Application` y `Supervisor` con Mix para proyectos OTP.

## Uso de Inteligencia Artificial

Se utilizó IA como apoyo para:
- Revisar patrones idiomáticos de Elixir (pattern matching, `with`, `case`).
- Sugerir la estructura de módulos y separación de responsabilidades.
- Verificar el manejo correcto de errores en las operaciones de archivo.

La lógica de negocio, validaciones y estructura general se cumplieron bien
