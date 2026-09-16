# Skills personales

Skills propias versionadas y skills externas fijadas por commit, compartidas entre usuarios de macOS.

## Instalar y sincronizar

Clona este repositorio en cada usuario y ejecuta desde su carpeta:

```sh
./scripts/bootstrap.sh --dry-run
./scripts/bootstrap.sh
```

El perfil inicial es `default`; `skills=("*")` en `skills-manifest.sh` incluye todas las carpetas de `skills/` y todas las externas declaradas. También se puede indicar `--profile default`.

El destino predeterminado es `${CODEX_HOME:-$HOME/.codex}/skills`. Para otro agente o un destino de prueba:

```sh
./scripts/bootstrap.sh --target-dir "$HOME/.claude/skills"
```

El bootstrap usa Bash 3.2, curl, tar, shasum y utilidades incluidas en macOS. No instala paquetes ni necesita Node, Python, jq o Git para instalar. Necesita conexión en la primera descarga de cada commit externo. Git se utiliza únicamente para clonar y actualizar este repositorio; macOS puede solicitar Command Line Tools si aún no está disponible.

Para recibir cambios publicados en el repositorio:

```sh
git pull --ff-only
./scripts/bootstrap.sh
```

Cada usuario mantiene su clon e instalación independientes. No hay sincronización automática en segundo plano. Reinicia el agente si aún no reconoce las nuevas skills.

## Contenido

- `skills/go-code-review/`: revisión profunda de Go, referencias y verificación opcional.
- `skills/create-business-adr/`: ADR con impacto empresarial y plantilla.
- `skills/go-documentation/`: revisión y mejora de documentación Go.
- `skills-manifest.sh`: selección y dependencias externas.
- `scripts/bootstrap.sh`: instalación mediante copias completas.

Las instrucciones y recursos originales se conservan; no se ejecutan los scripts de las skills durante la instalación. El helper de revisión requiere las herramientas de Go cuando se utiliza y no convierte su resultado en una validación del bootstrap.

## Añadir skills

Propias: añade `skills/nombre/SKILL.md` con frontmatter `name: nombre` y `description`. Conserva en esa carpeta referencias, scripts y metadatos auxiliares.

Externas: añade una entrada a `external_skills` con formato:

```text
nombre|owner/repo|SHA completo de 40 caracteres|ruta/de/la/skill
```

La externa inicial es [logging-best-practices](https://github.com/boristane/agent-skills/tree/8aa14dd16a1340a6049e6d7cd58e2ed52333a550/skills/logging-best-practices). Se copia toda su carpeta, incluyendo reglas y metadatos. Para actualizarla, revisa los cambios de origen, cambia su SHA en el manifest y publica ese cambio; el bootstrap nunca sigue `main` automáticamente.

El manifest es código Bash de confianza, no JSON ni YAML. No lo cargues desde un origen no revisado. Por ahora admite un único perfil; puedes sustituir `"*"` por nombres explícitos para seleccionar un subconjunto.

## Conflictos y estado

El bootstrap descarga y comprueba todas las skills seleccionadas antes de modificar sus destinos. Acepta copias idénticas y actualiza copias administradas sin cambios locales. Si encuentra otra instalación distinta o una copia modificada manualmente, se detiene con su ruta: respalda o mueve esa carpeta antes de repetir.

Las snapshots y descargas se guardan en `~/Library/Caches/personal-skills/` (o `$XDG_CACHE_HOME/personal-skills/`). Si borras esa caché, las copias idénticas se adoptan de nuevo; las distintas requerirán resolver el conflicto. No se eliminan automáticamente skills retiradas del manifest ni instalaciones ajenas. Evita editar las copias instaladas: edita las propias en este repositorio.

## Licencias

Las skills externas conservan su autoría y cualquier aviso de licencia incluido. Este repositorio no les asigna una licencia nueva. Antes de redistribuir o publicar copias externas, verifica los permisos de su origen. No se ha elegido todavía una licencia para las skills propias.
