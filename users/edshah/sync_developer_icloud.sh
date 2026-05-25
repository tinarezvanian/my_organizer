#!/bin/bash
# Merge ~/Developer into iCloud Developer (keeps iCloud-only projects).
# Native iCloud sync handles ongoing changes once ~/Developer -> iCloud/Developer.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "$SCRIPT_DIR/config.sh"

LOCAL="${LOCAL_DEVELOPER:-$HOME/Developer}"
ICLOUD="${ICLOUD_DEVELOPER:-$ICLOUD_ROOT/Developer}"

RSYNC_EXCLUDES=(
  --exclude '.DS_Store'
  --exclude 'node_modules/'
  --exclude '.venv/'
  --exclude 'venv/'
  --exclude '.micromamba/'
  --exclude '__pycache__/'
  --exclude '*.pyc'
  --exclude 'dist/'
  --exclude 'build/'
  --exclude '.next/'
  --exclude 'target/'
  --exclude 'DerivedData/'
  --exclude '*.xcuserstate'
)

usage() {
  cat <<EOF
Usage: $(basename "$0") [--dry-run] [--link]

  --dry-run   Show what would be copied (no changes)
  --link      Point ~/Developer at iCloud Developer (native sync).
              Moves existing ~/Developer to ~/Developer.pre-icloud-backup,
              then merges backup into iCloud in the background.
  --merge     Merge only (no symlink). Use after editing files in the backup copy.

Paths:
  Local:  $LOCAL
  iCloud: $ICLOUD
EOF
}

DRY_RUN=false
DO_LINK=false
DO_MERGE=true

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --link)    DO_LINK=true ;;
    --merge)   DO_MERGE=true; DO_LINK=false ;;
    --link-only) DO_LINK=true; DO_MERGE=false ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $arg"; usage; exit 1 ;;
  esac
done

mkdir -p "$ICLOUD"

BACKUP="$HOME/Developer.pre-icloud-backup"
MERGE_SOURCE="$LOCAL"

RSYNC_FLAGS=(-avh "${RSYNC_EXCLUDES[@]}")
if $DRY_RUN; then
  RSYNC_FLAGS=(-avhn "${RSYNC_EXCLUDES[@]}")
fi

run_merge() {
  local src="$1"
  echo "Merging $src/ -> $ICLOUD/"
  rsync "${RSYNC_FLAGS[@]}" "$src/" "$ICLOUD/"
}

# Already linked
if [[ -L "$LOCAL" ]]; then
  LINK_TARGET="$(readlink "$LOCAL")"
  if [[ "$LINK_TARGET" == "$ICLOUD" ]]; then
    echo "Already linked: $LOCAL -> $ICLOUD"
    if $DO_MERGE && [[ -d "$BACKUP" ]]; then
      run_merge "$BACKUP"
    fi
    exit 0
  fi
fi

if $DO_LINK && ! $DRY_RUN; then
  if [[ ! -L "$LOCAL" ]]; then
    if [[ -e "$BACKUP" ]]; then
      BACKUP="${BACKUP}-$(date +%Y%m%d%H%M%S)"
    fi
    echo "Moving $LOCAL -> $BACKUP"
    mv "$LOCAL" "$BACKUP"
    MERGE_SOURCE="$BACKUP"
  fi
  if [[ ! -L "$LOCAL" ]]; then
    echo "Linking $LOCAL -> $ICLOUD"
    ln -s "$ICLOUD" "$LOCAL"
    echo "iCloud now syncs $ICLOUD via $LOCAL"
  fi
fi

if $DO_MERGE; then
  if $DO_LINK && ! $DRY_RUN && [[ -d "$BACKUP" ]]; then
    LOG="$HOME/Developer-icloud-merge.log"
    echo "Background merge from $BACKUP -> $ICLOUD (log: $LOG)"
    nohup rsync -avh "${RSYNC_EXCLUDES[@]}" "$BACKUP/" "$ICLOUD/" >>"$LOG" 2>&1 &
    echo "Merge PID: $!"
  else
    run_merge "$MERGE_SOURCE"
  fi
fi
