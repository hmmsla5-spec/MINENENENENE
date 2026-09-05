#!/bin/bash
set -e

# ===== CONFIGURAÇÃO =====
BACKUP_REPO="hmmsla5-spec/crafty-backups"
# Pasta com os dados do Crafty (mundos, configs, tudo). Ajuste se o nome/local mudar.
DATA_DIR="/workspaces/MINENENENENE/SERVERS MINE"
# Pasta com a config do playit (guarda a chave que mantém o endereço do servidor fixo)
PLAYIT_DIR="/home/codespace/.config/playit_gg"
# =========================

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
ARCHIVE="/tmp/crafty-backup-${TIMESTAMP}.tar.gz"

echo "Compactando '${DATA_DIR}' e a config do playit..."
tar -czf "$ARCHIVE" \
  -C "$(dirname "$DATA_DIR")" "$(basename "$DATA_DIR")" \
  -C "$(dirname "$PLAYIT_DIR")" "$(basename "$PLAYIT_DIR")"

echo "Enviando pro repositório de backup..."
gh release create "backup-${TIMESTAMP}" "$ARCHIVE" \
  --repo "$BACKUP_REPO" \
  --title "Backup ${TIMESTAMP}" \
  --notes "Backup automático do Crafty + config do playit"

echo "Backup concluído: backup-${TIMESTAMP}"
rm -f "$ARCHIVE"