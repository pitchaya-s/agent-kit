#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
SKILLS_DIR="$ROOT/skills"
AGENT=""
CUSTOM_TARGET=""

usage() {
  cat <<'USAGE'
Usage: bash scripts/uninstall.sh --agent <codex|claude|opencode|gemini|copilot|cursor|shared|all>
       bash scripts/uninstall.sh --target <directory>
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

if [ -n "$AGENT" ] && [ -n "$CUSTOM_TARGET" ]; then
  echo "error: use either --agent or --target, not both" >&2
  exit 2
fi

if [ -z "$AGENT" ] && [ -z "$CUSTOM_TARGET" ]; then
  echo "error: choose an agent with --agent, or provide --target" >&2
  usage >&2
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

add_agent_target() {
  case "$1" in
    codex)    add_target "$HOME/.codex/skills" ;;
    claude)   add_target "$HOME/.claude/skills" ;;
    opencode) add_target "$HOME/.config/opencode/skills" ;;
    gemini)   add_target "$HOME/.gemini/skills" ;;
    copilot)  add_target "$HOME/.copilot/skills" ;;
    cursor)   add_target "$HOME/.cursor/skills" ;;
    shared)   add_target "$HOME/.agents/skills" ;;
    *)
      echo "error: unsupported agent: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
}

if [ -n "$CUSTOM_TARGET" ]; then
  add_target "$CUSTOM_TARGET"
elif [ "$AGENT" = "all" ]; then
  for agent in codex claude opencode gemini copilot cursor; do
    add_agent_target "$agent"
  done
else
  add_agent_target "$AGENT"
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
