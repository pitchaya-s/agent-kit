#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
SKILLS_DIR="$ROOT/skills"
AGENT="shared"
CUSTOM_TARGET=""

usage() {
  cat <<'USAGE'
Usage: bash scripts/uninstall.sh [--agent shared|codex|opencode|gemini|copilot|cursor|claude|all] [--target DIR]
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    -a|--agent)
      [ "$#" -ge 2 ] || { echo "error: --agent requires a value" >&2; exit 2; }
      AGENT="$2"
      shift 2
      ;;
    --target)
      [ "$#" -ge 2 ] || { echo "error: --target requires a directory" >&2; exit 2; }
      CUSTOM_TARGET="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [ -n "$CUSTOM_TARGET" ] && [ "$AGENT" != "shared" ]; then
  echo "error: use either --target or --agent, not both" >&2
  exit 2
fi

TARGETS=()
add_target() {
  local candidate="$1"
  local existing
  for existing in "${TARGETS[@]:-}"; do
    [ "$existing" = "$candidate" ] && return
  done
  TARGETS+=("$candidate")
}

if [ -n "$CUSTOM_TARGET" ]; then
  add_target "$CUSTOM_TARGET"
else
  case "$AGENT" in
    shared|codex|opencode|gemini|copilot|cursor)
      add_target "$HOME/.agents/skills"
      ;;
    claude)
      add_target "$HOME/.claude/skills"
      ;;
    all)
      add_target "$HOME/.agents/skills"
      add_target "$HOME/.claude/skills"
      ;;
    *)
      echo "error: unsupported agent: $AGENT" >&2
      usage >&2
      exit 2
      ;;
  esac
fi

SKILLS=()
shopt -s nullglob
for skill in "$SKILLS_DIR"/*; do
  [ -d "$skill" ] || continue
  [ -f "$skill/SKILL.md" ] || continue
  SKILLS+=("$skill")
done
shopt -u nullglob

if [ "${#SKILLS[@]}" -eq 0 ]; then
  echo "error: no skills found in $SKILLS_DIR" >&2
  exit 1
fi

for target in "${TARGETS[@]}"; do
  for skill in "${SKILLS[@]}"; do
    name="$(basename "$skill")"
    dest="$target/$name"

    if [ ! -L "$dest" ]; then
      if [ -e "$dest" ]; then
        echo "skipped: $dest exists but is not an agent-kit symlink" >&2
      else
        echo "not installed: $dest"
      fi
      continue
    fi

    if [ "$(readlink "$dest")" != "$skill" ]; then
      echo "skipped: $dest points somewhere else" >&2
      continue
    fi

    rm "$dest"
    echo "removed: $dest"
  done
done
