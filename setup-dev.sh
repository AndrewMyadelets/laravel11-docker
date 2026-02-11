#!/bin/bash

# Firewall configuration
echo "🔐 Configuring Firewall..."
NETWORK_NAME="laravel_laravel-network"
SUBNET=$(docker network inspect "$NETWORK_NAME" -f '{{range .IPAM.Config}}{{.Subnet}}{{end}}')

if [ -z "$SUBNET" ]; then
    echo "❌ Error: Network '$NETWORK_NAME' not found."
    exit 1
fi

sudo ufw allow from "$SUBNET" to any port 9003 proto tcp
echo "✅ Xdebug access granted ($SUBNET -> 9003)"

# Adding aliases to .bashrc (only if they don't exist)
echo "✍️ Checking aliases in ~/.bashrc..."

add_alias_if_not_exists() {
    local alias_line="$1"
    if ! grep -qF "$alias_line" ~/.bashrc; then
        echo "$alias_line" >> ~/.bashrc
        echo "➕ Added: $alias_line"
    else
        echo "🔘 Already exists: $alias_line"
    fi
}

add_alias_if_not_exists "alias dcel='docker compose exec laravel'"
add_alias_if_not_exists "alias pa='docker compose exec laravel php artisan'"

echo "----------------------------------------------------"
echo "🎉 Setup complete!"
echo "⚠️ To activate aliases in this window, run: source ~/.bashrc"
echo "Or just open a new terminal tab."
