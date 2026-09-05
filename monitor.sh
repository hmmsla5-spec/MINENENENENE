#!/bin/bash
set -e

# ===== CONFIGURAÇÃO =====
LIMITE_CORE_HOURS=120       # Free = 120, Pro = 180
AVISO_ABAIXO_DE=15          # dispara backup quando faltar menos que isso
INTERVALO_MINUTOS=20        # de quanto em quanto tempo checa
MARCADOR="/tmp/backup_auto_feito_hoje"
# =========================

USUARIO=$(gh api user --jq .login)

while true; do
  USADO=$(gh api "/users/$USUARIO/settings/billing/usage" --jq '
    [.usageItems[] | select(.product == "codespaces" and (.sku | contains("hours"))) | .quantity] | add // 0
  ')
  RESTANTE=$(echo "$LIMITE_CORE_HOURS - $USADO" | bc)

  echo "[$(date '+%d/%m %H:%M')] Core-hours restantes: $RESTANTE"

  if (( $(echo "$RESTANTE < $AVISO_ABAIXO_DE" | bc -l) )); then
    if [ ! -f "$MARCADOR" ] || [ "$(find "$MARCADOR" -mmin +1440)" ]; then
      echo "⚠️  Horas quase acabando! Rodando backup automático..."
      ./backup.sh
      touch "$MARCADOR"
      echo "✅ Backup automático concluído."
    else
      echo "(backup automático já feito nas últimas 24h, pulando)"
    fi
  fi

  sleep "$((INTERVALO_MINUTOS * 60))"
done
