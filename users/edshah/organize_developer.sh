#!/bin/bash
# Organize iCloud ~/Developer for edshah — see users/edshah/DEVELOPER_ORGANIZATION_GUIDE.md

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "$SCRIPT_DIR/config.sh"

ROOT="${ICLOUD_DEVELOPER:-$ICLOUD_ROOT/Developer}"
cd "$ROOT" || exit 1

DRY_RUN=false
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    -h|--help)
      echo "Usage: $(basename "$0") [--dry-run]"
      exit 0
      ;;
  esac
done

mv_dir() {
  local src="$1" dest="$2"
  [[ -d "$src" ]] || return 0
  [[ "$src" == "$dest" ]] && return 0
  if [[ -e "$dest" ]]; then
    echo "SKIP (exists): $dest"
    return 0
  fi
  if $DRY_RUN; then
    echo "mv $src -> $dest"
  else
    mv "$src" "$dest"
    echo "moved: $(basename "$src") -> $(dirname "$dest")/"
  fi
}

rm_empty() {
  local path="$1"
  [[ -d "$path" ]] || return 0
  if [[ -z "$(ls -A "$path" 2>/dev/null)" ]]; then
    if $DRY_RUN; then
      echo "rmdir $path"
    else
      rmdir "$path" && echo "removed empty: $(basename "$path")"
    fi
  fi
}

mkdir -p Projects Tools Learning Media Personal

# --- Projects (code repos and project dirs) ---
PROJECTS=(
  acip agent_invest bridge coa_llm commerce-reference
  conduit conduit-iOS conduit-manager conduit-manager-mac conduit-relay conduit_emergency
  DarkForest-Hunter-OpenAI dd dlm_helper gpt_project
  iran-conduit-firewall lidar_notebook LLMs myOpenClaw
  nfl_stream polymarket-bot radarinformer raman raman_chem rfcb
  vet_sbir vinetka voiceover
)
for name in "${PROJECTS[@]}"; do
  mv_dir "$ROOT/$name" "$ROOT/Projects/$name"
done

# --- Tools (editor/IDE data) ---
TOOLS=(
  Cline "Phoenix Code" QtDesignStudio React "Raspberry Pi Emulator"
)
for name in "${TOOLS[@]}"; do
  mv_dir "$ROOT/$name" "$ROOT/Tools/$name"
done

# --- Learning ---
for name in Algorithmic_Adventures TAlgorithmic_Adventures; do
  mv_dir "$ROOT/$name" "$ROOT/Learning/$name"
done

# --- Media / Personal ---
mv_dir "$ROOT/videos" "$ROOT/Media/videos"
mv_dir "$ROOT/ehsan_resume" "$ROOT/Personal/ehsan_resume"

rm_empty "$ROOT/untitled folder"

echo ""
echo "Done. Top-level under Developer:"
if $DRY_RUN; then
  echo "(dry-run — no changes made)"
else
  ls -1
fi
