#!/usr/bin/env bash
# ==============================================================================
# Script de Configuração Inicial da VPS Ubuntu para o "Siga o Verbo"
# Executar na VPS recém-criada como root ou com sudo:
# curl -fsSL https://raw.githubusercontent.com/.../setup-vps.sh | bash
# ==============================================================================

set -euo pipefail

echo "==> [1/4] Atualizando pacotes do sistema Ubuntu..."
apt-get update -y && apt-get upgrade -y
apt-get install -y curl rsync ufw debian-keyring debian-archive-keyring apt-transport-https

echo "==> [2/4] Instalando Caddy Server (Repositório Oficial)..."
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg --yes
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
apt-get update -y
apt-get install -y caddy

echo "==> [3/4] Criando diretório do blog e ajustando permissões..."
mkdir -p /var/www/siga-o-verbo
chown -R www-data:www-data /var/www/siga-o-verbo
chmod -R 755 /var/www/siga-o-verbo

echo "==> [4/4] Configurando Firewall (UFW) para portas 80, 443 e 22..."
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

echo "================================================================================"
echo "Instalação concluída com sucesso!"
echo "Próximos passos:"
echo "1. Copie o arquivo 'Caddyfile' para '/etc/caddy/Caddyfile' na VPS"
echo "2. Edite o domínio no Caddyfile com seu domínio real"
echo "3. Reinicie o Caddy: systemctl reload caddy"
echo "O certificado SSL será emitido e renovado de forma 100% automática pelo Caddy."
echo "================================================================================"
