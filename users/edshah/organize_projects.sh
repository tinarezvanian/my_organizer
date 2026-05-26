#!/bin/bash
# Organize ~/Developer/Projects for edshah — see users/edshah/PROJECTS_ORGANIZATION_GUIDE.md

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "$SCRIPT_DIR/config.sh"

PROJ="${ICLOUD_DEVELOPER:-$ICLOUD_ROOT/Developer}/Projects"
cd "$PROJ" || exit 1

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

# Category dirs — do not treat as projects to move
CATEGORIES=(conduit ai-agents science web media homelab)

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

# When a project dir has the same name as its category (e.g. conduit/conduit),
# stage the repo aside, create the category folder, then nest the repo.
ensure_category() {
  local cat="$1"
  local nested="$PROJ/$cat/$cat"
  [[ -d "$nested" ]] && return 0
  if [[ -d "$PROJ/$cat/.git" || -f "$PROJ/$cat/README.md" ]]; then
    local staging="$PROJ/.organize_staging_${cat}"
    if $DRY_RUN; then
      echo "stage $PROJ/$cat -> $staging, mkdir $cat, mv -> $nested"
    else
      mv "$PROJ/$cat" "$staging"
      mkdir -p "$PROJ/$cat"
      mv "$staging" "$nested"
      echo "nested: $cat -> $cat/$cat"
    fi
  else
    mkdir -p "$PROJ/$cat"
  fi
}

move_category() {
  local cat="$1"
  shift
  ensure_category "$cat"
  for name in "$@"; do
    [[ "$name" == "$cat" ]] && continue
    [[ " ${CATEGORIES[*]} " == *" $name "* ]] && continue
    mv_dir "$PROJ/$name" "$PROJ/$cat/$name"
  done
}

move_category conduit \
  conduit conduit-iOS conduit-manager conduit-manager-mac conduit-relay conduit_emergency \
  iran-conduit-firewall iran-conduit-firewall-1.1.1

move_category ai-agents \
  LLMs agent_invest acip gpt_project coa_llm myOpenClaw polymarket-bot DarkForest-Hunter-OpenAI

move_category science \
  raman raman_chem lidar_notebook radarinformer vet_sbir bridge

move_category web \
  commerce-reference dd vinetka

move_category media \
  nfl_stream voiceover

move_category homelab \
  dlm_helper tpb_syno_search rfcb

# Loose files at Projects root (not dirs) — report only
shopt -s nullglob
loose=(*)
shopt -u nullglob
for f in "${loose[@]}"; do
  [[ -f "$f" ]] && echo "NOTE: loose file at Projects root: $f"
done

echo ""
echo "Done. Top-level under Projects:"
if $DRY_RUN; then
  echo "(dry-run — no changes made)"
else
  ls -1
fi
