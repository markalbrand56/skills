#!/usr/bin/env sh
# Optional verification helper. Portable POSIX shell; no agent-specific APIs.
set -u

run() {
  name="$1"
  shift
  printf '\n== %s ==\n' "$name"
  if command -v "$1" >/dev/null 2>&1; then
    "$@"
  else
    printf 'SKIPPED: %s not installed\n' "$1"
  fi
}

run "gofmt" gofmt -l .
run "go test" go test ./...
run "go vet" go vet ./...

if command -v staticcheck >/dev/null 2>&1; then
  run "staticcheck" staticcheck ./...
else
  printf '\n== staticcheck ==\nSKIPPED: staticcheck not installed\n'
fi
