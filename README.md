# Laravel 11 Docker Development Environment

## About

This repository contains a containerized Laravel 11.48 development environment with PHP 8.4, MySQL 8.0, phpMyAdmin, and pre-configured Xdebug 3.

### Prerequisites
- Docker and Docker Compose installed.
- ufw (Uncomplicated Firewall) installed (standard on Ubuntu/Debian).

### Features
- Fully containerized environment (no local PHP/MySQL required)
- Xdebug enabled with automatic start (mode=debug + start_with_request=yes)
- PhpMyAdmin available at http://localhost:8081
- MySQL accessible from host (port 3306)
- Persistent data volumes for MySQL
- Laravel optimized Nginx configuration

## Installation & Setup
Follow these steps to deploy the project locally:

#### 1. Clone the repository:
```bash
git clone https://github.com/AndrewMyadelets/laravel11-docker.git
cd laravel11-docker
```

#### 2. Prepare environment files
```bash
cp .env.example .env
```

#### 3. Build and start containers
```bash
docker compose up -d --build
```

#### 4. Run the development setup script (Optional)
This script configures the host firewall for Xdebug and adds convenient shell aliases (dcel, pa).
```bash
chmod +x setup-dev.sh
./setup-dev.sh
source ~/.bashrc
```

#### 5. Finalize Laravel initialization
Since initialization is not automated in scripts, run these manually:
```bash
# Install dependencies
dcel composer install

# Generate application key
pa key:generate

# Run database migrations
pa migrate
```
## Usage & Commands
Thanks to the setup-dev.sh script, you can use the following aliases:

| Alias | Full Command | Description |
|---|---|---|
| dcel | docker compose exec laravel | Execute any command inside the PHP container |
| pa | docker compose exec laravel php artisan | Run Laravel Artisan commands |

#### Examples:
```bash
pa make:controller UserController
dcel php -v
pa tinker
```
