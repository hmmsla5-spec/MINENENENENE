#!/bin/bash
set -e

BACKUP_REPO="hmmsla5-spec/crafty-backups"
DATA_DIR="/workspaces/MINENENENENE/SERVERS MINE"
PLAYIT_DIR="/home/codespace/.config/playit_gg"

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
ARCHIVE="/tmp/crafty-backup-${TIMESTAMP}.tar.gz"

echo "Compactando '${DATA_DIR}' (sem .venv) e a config do playit..."
tar -czf "$ARCHIVE" \
  --exclude="$(basename "$DATA_DIR")/.venv" \
  --exclude="$(basename "$DATA_DIR")/crafty-4/.venv" \
  -C "$(dirname "$DATA_DIR")" "$(basename "$DATA_DIR")" \
  -C "$(dirname "$PLAYIT_DIR")" "$(basename "$PLAYIT_DIR")" 2>/dev/null || \
tar -czf "$ARCHIVE" \
  --exclude="$(basename "$DATA_DIR")/.venv" \
  --exclude="$(basename "$DATA_DIR")/crafty-4/.venv" \
  -C "$(dirname "$DATA_DIR")" "$(basename "$DATA_DIR")"

echo "Enviando pro repositório de backup..."
gh release create "backup-${TIMESTAMP}" "$ARCHIVE" \
  --repo "$BACKUP_REPO" \
  --title "Backup ${TIMESTAMP}" \
  --notes "Backup automático do Crafty + config do playit"

echo "Backup concluído: backup-${TIMESTAMP}"
rm -f "$ARCHIVE"