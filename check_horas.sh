#!/bin/bash
set -e

# ===== CONFIGURAÇÃO =====
# Limite de core-hours incluído no seu plano (Free = 120, Pro = 180)
LIMITE_CORE_HOURS=120
# Avisar quando faltar menos que isso (em core-hours)
AVISO_ABAIXO_DE=15
# =========================

USUARIO=$(gh api user --jq .login)

echo "Consultando uso de $USUARIO..."
USADO=$(gh api "/users/$USUARIO/settings/billing/usage" --jq '
  [.usageItems[] | select(.product == "codespaces" and (.sku | contains("hours"))) | .quantity] | add // 0
')

RESTANTE=$(echo "$LIMITE_CORE_HOURS - $USADO" | bc)

echo "Core-hours usados: $USADO"
echo "Core-hours restantes (estimado): $RESTANTE"

if (( $(echo "$RESTANTE < $AVISO_ABAIXO_DE" | bc -l) )); then
  echo ""
  echo "⚠️  ATENÇÃO: faltam menos de $AVISO_ABAIXO_DE core-hours!"
  echo "⚠️  Rode ./backup.sh AGORA antes que o Codespace pare de funcionar."
fi
