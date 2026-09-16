#!/bin/bash
# Compatible con Bash 3.2 incluido en macOS. No requiere Node, Python ni jq.
set -eo pipefail
repo_dir="$(cd "$(dirname "$0")/.." && pwd)"
target_dir="${CODEX_HOME:-$HOME/.codex}/skills"
dry_run=false
requested_profile=default
usage() {
  echo "Uso: $0 [--profile default] [--dry-run] [--target-dir RUTA]"
}
while [ "$#" -gt 0 ]; do
  case "$1" in
    --profile|--target-dir)
      [ "$#" -ge 2 ] || { usage >&2; exit 1; }
      case "$1" in --profile) requested_profile="$2";; --target-dir) target_dir="$2";; esac
      shift 2;;
    --dry-run) dry_run=true; shift;;
    -h|--help) usage; exit 0;;
    *) usage >&2; exit 1;;
  esac
done
fail() { echo "ERROR: $*" >&2; exit 1; }
[ "$(uname -s)" = Darwin ] || fail "Esta versión requiere macOS."
source "$repo_dir/skills-manifest.sh"
[ "$requested_profile" = "$profile" ] || fail "Perfil desconocido: $requested_profile"
valid_name() { [[ "$1" =~ ^[a-z0-9][a-z0-9-]*$ ]]; }
selected() {
  local item
  for item in "${skills[@]}"; do
    [ "$item" = '*' ] || [ "$item" = "$1" ] || continue
    return 0
  done
  return 1
}
names=(); sources=()
add_skill() {
  local existing
  valid_name "$1" || fail "Nombre inválido: $1"
  for existing in "${names[@]}"; do
    [ "$existing" != "$1" ] || fail "Skill duplicada: $1"
  done
  names+=("$1"); sources+=("$2")
}
for folder in "$repo_dir"/skills/*; do
  [ -d "$folder" ] || continue
  [ -f "$folder/SKILL.md" ] || fail "Falta SKILL.md: $folder"
  add_skill "$(basename "$folder")" "$folder"
done
# Primero validar el manifest completo; --dry-run no descarga ni escribe.
for entry in "${external_skills[@]}"; do
  IFS='|' read -r name repository commit skill_path extra <<< "$entry"
  [[ "$repository" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] || fail "Repositorio inválido"
  [[ "$commit" =~ ^[0-9a-f]{40}$ ]] || fail "El commit debe ser un SHA completo"
  [[ "$skill_path" =~ ^[A-Za-z0-9_/-]+$ ]] && [[ "/$skill_path/" != *'/../'* ]] || fail "Ruta inválida"
  [ -z "${extra:-}" ] || fail "Entrada externa inválida"
  add_skill "$name" "external:$entry"
done
for item in "${skills[@]}"; do
  [ "$item" != '*' ] || continue
  found=false
  for name in "${names[@]}"; do [ "$name" != "$item" ] || found=true; done
  $found || fail "Skill desconocida: $item"
done
[ "${#names[@]}" -gt 0 ] || fail "No hay skills"
if $dry_run; then
  for name in "${names[@]}"; do
    if selected "$name"; then printf 'Instalar/sincronizar %s → %s/%s\n' "$name" "$target_dir" "$name"; fi
  done
  exit 0
fi
# Estado separado por destino; snapshots detectan cambios locales antes de reemplazar.
state_key="$(printf '%s' "$target_dir" | shasum -a 256 | awk '{print $1}')"
state_dir="${XDG_CACHE_HOME:-$HOME/Library/Caches}/personal-skills/$state_key"
mkdir -p "$state_dir"
lock_dir="$state_dir/lock"
mkdir "$lock_dir" 2>/dev/null || fail "Ya hay un bootstrap activo para este destino: $lock_dir"
staging_dir="$(mktemp -d "$state_dir/staging.XXXXXX")"
trap 'rm -rf "$staging_dir"; rmdir "$lock_dir"' EXIT
for ((i=0; i<${#names[@]}; i++)); do
  name="${names[$i]}"
  selected "$name" || continue
  source_dir="${sources[$i]}"
  if [[ "$source_dir" = external:* ]]; then
    IFS='|' read -r name repository commit skill_path <<< "${source_dir#external:}"
    cache_dir="$state_dir/sources/${repository//\//-}/$commit"
    if [ ! -f "$cache_dir/$skill_path/SKILL.md" ]; then
      archive="$staging_dir/source.tar.gz"
      curl --fail --location --silent --show-error --retry 2 \
        "https://codeload.github.com/$repository/tar.gz/$commit" -o "$archive"
      unpack="$staging_dir/unpack-$i"
      mkdir "$unpack"
      tar -xzf "$archive" --strip-components=1 -C "$unpack"
      [ -f "$unpack/$skill_path/SKILL.md" ] || fail "La externa no contiene SKILL.md"
      mkdir -p "$(dirname "$cache_dir")"
      mv "$unpack" "$cache_dir"
    fi
    source_dir="$cache_dir/$skill_path"
  fi
  mkdir "$staging_dir/$name"
  cp -R "$source_dir/." "$staging_dir/$name/"
  # Verificar que el nombre declarado coincide con la carpeta.
  declared="$(sed -n '/^---$/,/^---$/p' "$source_dir/SKILL.md" | sed -n 's/^name: *//p' | head -n 1 | tr -d '\"\047\r')"
  [ "$declared" = "$name" ] || fail "Nombre del SKILL.md distinto: $name ($declared)"
  destination="$target_dir/$name"
  if [ -e "$destination" ] || [ -L "$destination" ]; then
    [ -d "$destination" ] && [ ! -L "$destination" ] || fail "Destino incompatible: $destination"
    if diff -qr "$destination" "$staging_dir/$name" >/dev/null; then
      : # Se puede adoptar una copia idéntica.
    elif [ -d "$state_dir/installed/$name" ] && diff -qr "$destination" "$state_dir/installed/$name" >/dev/null; then
      : # Copia administrada que no fue modificada localmente.
    else
      fail "Conflicto en $destination. Respalda o mueve esa carpeta y vuelve a ejecutar."
    fi
  fi
done
# Solo instalar cuando todas las skills seleccionadas pasaron la comprobación.
mkdir -p "$target_dir" "$state_dir/installed"
for name in "${names[@]}"; do
  selected "$name" || continue
  destination="$target_dir/$name"
  if [ -d "$destination" ] && diff -qr "$destination" "$staging_dir/$name" >/dev/null; then
    echo "Sin cambios: $name"
  else
    # Mantener copia recuperable hasta completar el reemplazo.
    if [ -d "$destination" ]; then mv "$destination" "$staging_dir/previous-$name"; fi
    if ! mv "$staging_dir/$name" "$destination"; then
      if [ -d "$staging_dir/previous-$name" ]; then mv "$staging_dir/previous-$name" "$destination"; fi
      fail "No se pudo instalar $name"
    fi
    echo "Sincronizada: $name"
  fi
  rm -rf "$state_dir/installed/$name"
  cp -R "$destination" "$state_dir/installed/$name"
done
echo "Listo. Reinicia Codex si las skills nuevas todavía no aparecen."
