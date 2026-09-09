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

echo "Fatiando o arquivo em pedaços de 1.9GB..."
split -b 1900M "$ARCHIVE" "${ARCHIVE}_part_"

echo "Enviando os pedaços pro repositório de backup..."
gh release create "backup-${TIMESTAMP}" "${ARCHIVE}_part_"* \
  --repo "$BACKUP_REPO" \
  --title "Backup ${TIMESTAMP}" \
  --notes "Backup automático dividido em partes"

echo "Backup concluído: backup-${TIMESTAMP}"
rm -f "$ARCHIVE" "${ARCHIVE}_part_"*

echo "Limpando releases antigas (mantendo apenas as 2 mais recentes)..."
gh release list --repo "$BACKUP_REPO" --limit 50 | awk '{print $1}' | tail -n +3 | while read -r old_tag; do
  if [ -n "$old_tag" ]; then
    echo "Removendo release antiga: $old_tag"
    gh release delete "$old_tag" --repo "$BACKUP_REPO" --yes || true
    git push origin --delete "$old_tag" 2>/dev/null || true
  fi
done

echo "Processo finalizado com sucesso!"