#!/bin/bash
set -e

# ===== CONFIGURAÇÃO =====
BACKUP_REPO="hmmsla5-spec/crafty-backups"
# Pasta onde os dados devem ser restaurados (a pasta PAI de "SERVERS MINE")
RESTORE_TARGET="/workspaces/MINENENENENE"
# =========================

echo "Buscando o backup mais recente em $BACKUP_REPO..."
LATEST=$(gh release list --repo "$BACKUP_REPO" --limit 1 | cut -f3)

if [ -z "$LATEST" ]; then
  echo "Nenhum backup encontrado no repositório."
  exit 1
fi

echo "Baixando release: $LATEST"
mkdir -p /tmp/restore
gh release download "$LATEST" --repo "$BACKUP_REPO" --dir /tmp/restore --clobber

echo "Restaurando dentro de $RESTORE_TARGET..."
tar -xzf /tmp/restore/*.tar.gz -C "$RESTORE_TARGET"

echo "Restauração concluída! Verifique a pasta 'SERVERS MINE'."
rm -rf /tmp/restore
