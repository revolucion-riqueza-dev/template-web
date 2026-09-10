#!/usr/bin/env bash
###############################################################
#  setup.sh — Configuración inicial del proyecto
#
#  Ejecutar una sola vez después de clonar el repositorio.
#  Equivale a los Pasos 3-7 del README.
#
#  Uso:
#    bash setup.sh
###############################################################

set -e

# ── Colores ───────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${GREEN}[setup]${NC} $1"; }
warn()    { echo -e "${YELLOW}[setup]${NC} $1"; }
error()   { echo -e "${RED}[setup] ERROR:${NC} $1"; exit 1; }

# ── Verificaciones previas ────────────────────────────────────
info "Verificando herramientas necesarias..."

command -v php      >/dev/null 2>&1 || error "PHP no está instalado. Consulta el README -> Requisitos previos."
command -v composer >/dev/null 2>&1 || error "Composer no está instalado. Consulta el README -> Requisitos previos."

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
if [[ "$PHP_VERSION" < "8.4" ]]; then
    warn "Se detectó PHP $PHP_VERSION. Este proyecto requiere PHP 8.4."
fi

info "PHP $PHP_VERSION y Composer encontrados."

# ── Paso 3: Crear el proyecto Laravel ─────────────────────────
if [ -d "backend-arch" ]; then
    warn "La carpeta backend-arch ya existe. Eliminándola..."
    rm -rf backend-arch
fi

info "Paso 3/5 — Creando el proyecto Laravel 12..."
mv backend backend-arch

composer create-project laravel/laravel backend "^12.0" --no-interaction --quiet

info "Copiando capas de Clean Architecture..."
cp -r backend-arch/app/Domain         backend/app/
cp -r backend-arch/app/Application    backend/app/
cp -r backend-arch/app/Infrastructure backend/app/
cp -r backend-arch/app/Presentation   backend/app/

info "Copiando Dockerfiles y .env.example..."
cp backend-arch/Dockerfile     backend/Dockerfile
cp backend-arch/Dockerfile.dev backend/Dockerfile.dev
cp backend-arch/.env.example   backend/.env.example

info "Copiando seeder vacío..."
cp backend-arch/database/seeders/DatabaseSeeder.php backend/database/seeders/DatabaseSeeder.php

rm -rf backend-arch

# ── Paso 4: Eliminar frontend de Laravel ─────────────────────
info "Paso 4/5 — Eliminando archivos de frontend de Laravel..."
cd backend
rm -rf resources
rm -f  package.json vite.config.js
cd ..

# ── Paso 5: Eliminar migraciones por defecto ──────────────────
info "Paso 5/5 — Eliminando migraciones por defecto de Laravel..."
rm -f backend/database/migrations/0001_01_01_000000_create_users_table.php
rm -f backend/database/migrations/0001_01_01_000001_create_cache_table.php
rm -f backend/database/migrations/0001_01_01_000002_create_jobs_table.php

# ── Cambiar motor de BD por defecto ──────────────────────────
info "Configurando PostgreSQL como motor de BD por defecto..."
php -r "
\$file = 'backend/config/database.php';
\$content = file_get_contents(\$file);
\$content = str_replace(
    \"'default' => env('DB_CONNECTION', 'sqlite')\",
    \"'default' => env('DB_CONNECTION', 'pgsql')\",
    \$content
);
file_put_contents(\$file, \$content);
echo 'database.php actualizado' . PHP_EOL;
"

# ── Registrar RepositoryServiceProvider ──────────────────────
info "Registrando RepositoryServiceProvider..."
php -r "
\$file = 'backend/bootstrap/providers.php';
\$content = file_get_contents(\$file);
\$provider = 'App\\\Infrastructure\\\Providers\\\RepositoryServiceProvider::class,';
if (strpos(\$content, \$provider) === false) {
    \$content = str_replace(
        'App\\\Providers\\\AppServiceProvider::class,',
        'App\\\Providers\\\AppServiceProvider::class,' . PHP_EOL . '    ' . \$provider,
        \$content
    );
    file_put_contents(\$file, \$content);
    echo 'providers.php actualizado' . PHP_EOL;
} else {
    echo 'RepositoryServiceProvider ya registrado' . PHP_EOL;
}
"

# ── Listo ─────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}  Configuracion inicial completada.${NC}"
echo ""
echo "  Siguientes pasos:"
echo "  1. Configura tus variables de entorno:"
echo "     cp .env.example .env"
echo "     cp backend/.env.example backend/.env"
echo "     cp frontend/.env.example frontend/.env.local"
echo "     (Edita cada .env con tus credenciales de BD)"
echo ""
echo "  2. Levanta el entorno:"
echo "     make install"
echo ""