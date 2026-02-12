#!/bin/bash

#!/bin/bash

# 1. Load variables from .env
if [ -f .env ]; then
    set -a
    source .env
    set +a
else
    echo "ERROR: .env file not found."
    exit 1
fi

# 2. Identify the network name dynamically
NETWORK_SUFFIX="_${DOCKER_NETWORK}"
FULL_NETWORK_NAME=$(docker network ls --format "{{.Name}}" | grep "${NETWORK_SUFFIX}$" | head -n 1)

echo "Searching for suffix: $NETWORK_SUFFIX"
echo "Found Network: $FULL_NETWORK_NAME"

# 3. Check if network was found
if [ -z "$FULL_NETWORK_NAME" ]; then
    echo "ERROR: Network ending with '$NETWORK_SUFFIX' not found."
    echo "Please run: docker compose up -d"
    exit 1
fi

# 4. Get the Subnet and configure UFW
SUBNET=$(docker network inspect "$FULL_NETWORK_NAME" -f '{{range .IPAM.Config}}{{.Subnet}}{{end}}' 2>/dev/null)

if [ -z "$SUBNET" ]; then
    echo "ERROR: Network '$FULL_NETWORK_NAME' not found."
    echo "Please run: docker compose up -d"
    exit 1
fi

sudo ufw allow from "$SUBNET" to any port 9003 proto tcp
echo "SUCCESS: Xdebug access granted ($SUBNET -> 9003)"

# 5. Adding aliases to .bashrc
echo "Checking aliases..."

add_alias_if_not_exists() {
    local alias_line="$1"
    if ! grep -qF "$alias_line" ~/.bashrc; then
        echo "$alias_line" >> ~/.bashrc
        echo "ADDED: $alias_line"
    else
        echo "EXISTS: $alias_line"
    fi
}

add_alias_if_not_exists "alias dcel='docker compose exec laravel'"
add_alias_if_not_exists "alias pa='docker compose exec laravel php artisan'"

echo "----------------------------------------------------"
echo "Setup complete!"
echo "Run 'source ~/.bashrc' to activate aliases."
