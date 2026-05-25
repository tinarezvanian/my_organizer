#!/bin/bash
# Copy Takeout 2_organized from iCloud to Synology, verify, then remove from iCloud.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "$SCRIPT_DIR/config.sh"

SRC="${TAKEOUT_ICLOUD:-$ICLOUD_ROOT/Takeout 2_organized}"
DEST_REMOTE="${TAKEOUT_NAS:-/volume1/homes/edshah/Drive/archive/Takeout_2_organized}"
NAS_SSH="${NAS_SSH_HOST:-edshah@matador}"
LOG="${TAKEOUT_MOVE_LOG:-$HOME/Takeout-2-nas-move.log}"

usage() {
  cat <<EOF
Usage: $(basename "$0") [--dry-run] [--copy-only]

  --dry-run    Show rsync plan only (no copy, no delete)
  --copy-only  Copy to NAS but do not remove from iCloud

Uses rsync over SSH (more reliable than SMB for large files).

Paths:
  Source:      $SRC
  Destination: $NAS_SSH:$DEST_REMOTE
EOF
}

DRY_RUN=false
COPY_ONLY=false

for arg in "$@"; do
  case "$arg" in
    --dry-run)   DRY_RUN=true ;;
    --copy-only) COPY_ONLY=true ;;
    -h|--help)   usage; exit 0 ;;
    *) echo "Unknown option: $arg"; usage; exit 1 ;;
  esac
done

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"
}

[[ -d "$SRC" ]] || { echo "Source not found: $SRC" >&2; exit 1; }

SRC_KB="$(du -sk "$SRC" | awk '{print $1}')"
AVAIL_KB="$(ssh "$NAS_SSH" "df -k '$DEST_REMOTE' | awk 'NR==2 {print \$4}'")"
if (( AVAIL_KB < SRC_KB * 105 / 100 )); then
  AVAIL_GB=$((AVAIL_KB / 1024 / 1024))
  SRC_GB=$((SRC_KB / 1024 / 1024))
  echo "NAS has ~${AVAIL_GB}GB free but source is ~${SRC_GB}GB — free space on /volume1 first." >&2
  exit 1
fi

RSYNC_FLAGS=(-avh --progress --partial --timeout=600 -W --exclude '.DS_Store')
if $DRY_RUN; then
  RSYNC_FLAGS=(-avhn --exclude '.DS_Store')
fi

download_icloud_source() {
  if ! command -v brctl >/dev/null; then
    return 0
  fi
  log "Ensuring iCloud files are downloaded locally: $SRC"
  brctl download "$SRC" || true
}

download_icloud_source
log "Copying $SRC -> $NAS_SSH:$DEST_REMOTE (ssh)"
ssh "$NAS_SSH" "mkdir -p '$DEST_REMOTE'"

attempt=1
max_attempts=5
while (( attempt <= max_attempts )); do
  if rsync "${RSYNC_FLAGS[@]}" "$SRC/" "$NAS_SSH:$DEST_REMOTE/"; then
    break
  fi
  log "rsync attempt $attempt failed — retrying after re-download"
  download_icloud_source
  sleep 10
  (( attempt++ )) || true
done
if (( attempt > max_attempts )); then
  echo "rsync failed after $max_attempts attempts" >&2
  exit 1
fi

if $DRY_RUN || $COPY_ONLY; then
  exit 0
fi

SRC_SIZE="$(du -sk "$SRC" | awk '{print $1}')"
DEST_SIZE="$(ssh "$NAS_SSH" "du -sk '$DEST_REMOTE'" | awk '{print $1}')"
log "Size check: source=${SRC_SIZE}KB dest=${DEST_SIZE}KB"

if (( DEST_SIZE < SRC_SIZE * 99 / 100 )); then
  echo "Destination smaller than source — not deleting iCloud copy." >&2
  exit 1
fi

log "Removing iCloud source: $SRC"
rm -rf "$SRC"
log "Done."
