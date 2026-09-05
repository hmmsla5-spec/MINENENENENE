#!/bin/bash
set -e

# ===== CONFIGURAÇÃO =====
BACKUP_REPO="hmmsla5-spec/crafty-backups"
# Pasta onde os dados do servidor devem ser restaurados (a pasta PAI de "SERVERS MINE")
RESTORE_TARGET="/workspaces/MINENENENENE"
# Pasta onde a config do playit deve ser restaurada
PLAYIT_TARGET="/home/codespace/.config"
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

echo "Extraindo backup..."
mkdir -p /tmp/restore_extract
tar -xzf /tmp/restore/*.tar.gz -C /tmp/restore_extract

echo "Restaurando 'SERVERS MINE' em $RESTORE_TARGET..."
rm -rf "$RESTORE_TARGET/SERVERS MINE"
mv "/tmp/restore_extract/SERVERS MINE" "$RESTORE_TARGET/"

if [ -d "/tmp/restore_extract/playit_gg" ]; then
  echo "Restaurando config do playit em $PLAYIT_TARGET..."
  mkdir -p "$PLAYIT_TARGET"
  rm -rf "$PLAYIT_TARGET/playit_gg"
  mv /tmp/restore_extract/playit_gg "$PLAYIT_TARGET/"
else
  echo "Aviso: backup antigo sem config do playit — endereço do servidor pode mudar."
fi

echo "Restauração concluída!"
rm -rf /tmp/restore /tmp/restore_extract