###############################################################
#  Makefile — Comandos del proyecto
#  Uso: make <comando>
###############################################################

COMPOSE_DEV  = docker compose -f docker-compose.dev.yml
COMPOSE_PROD = docker compose -f docker-compose.yml

.PHONY: help up down restart build logs shell-be shell-fe migrate seed fresh test artisan

# ── Ayuda ──────────────────────────────────────────────────
help: ## Muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ── Desarrollo ─────────────────────────────────────────────
up: ## Levanta el entorno de desarrollo
	$(COMPOSE_DEV) up -d

up-tools: ## Levanta con herramientas opcionales (pgAdmin)
	$(COMPOSE_DEV) --profile tools up -d

down: ## Detiene y elimina los contenedores de desarrollo
	$(COMPOSE_DEV) down

restart: ## Reinicia todos los servicios de desarrollo
	$(COMPOSE_DEV) restart

build: ## Reconstruye las imágenes de desarrollo
	$(COMPOSE_DEV) build --no-cache

logs: ## Muestra logs en tiempo real
	$(COMPOSE_DEV) logs -f

logs-be: ## Logs del backend
	$(COMPOSE_DEV) logs -f backend

logs-fe: ## Logs del frontend
	$(COMPOSE_DEV) logs -f frontend

# ── Shells ─────────────────────────────────────────────────
shell-be: ## Abre una shell en el contenedor del backend
	$(COMPOSE_DEV) exec backend sh

shell-fe: ## Abre una shell en el contenedor del frontend
	$(COMPOSE_DEV) exec frontend sh

shell-db: ## Abre psql en el contenedor de PostgreSQL
	$(COMPOSE_DEV) exec postgres psql -U $${DB_USERNAME:-app_user} -d $${DB_DATABASE:-app_db}

# ── Laravel ────────────────────────────────────────────────
migrate: ## Ejecuta las migraciones pendientes
	$(COMPOSE_DEV) exec backend php artisan migrate

seed: ## Ejecuta los seeders
	$(COMPOSE_DEV) exec backend php artisan db:seed

fresh: ## Limpia la BD y re-ejecuta migraciones + seeders
	$(COMPOSE_DEV) exec backend php artisan migrate:fresh --seed

artisan: ## Ejecuta un comando artisan: make artisan CMD="route:list"
	$(COMPOSE_DEV) exec backend php artisan $(CMD)

# ── Tests ──────────────────────────────────────────────────
test-be: ## Tests del backend (PHPUnit)
	$(COMPOSE_DEV) exec backend php artisan test

test-fe: ## Tests del frontend (Jest)
	$(COMPOSE_DEV) exec frontend npm test

# ── Instalación inicial ────────────────────────────────────
install: ## Primera instalación: copia .env y genera key de Laravel
	@cp -n backend/.env.example backend/.env 2>/dev/null || true
	@cp -n frontend/.env.example frontend/.env.local 2>/dev/null || true
	@cp -n .env.example .env 2>/dev/null || true
	$(COMPOSE_DEV) build
	$(COMPOSE_DEV) up -d
	$(COMPOSE_DEV) exec backend composer install
	$(COMPOSE_DEV) exec backend php artisan key:generate
	$(COMPOSE_DEV) exec backend php artisan migrate
	$(COMPOSE_DEV) exec frontend npm install
	@echo "\n✅  Instalación completa. Accede en http://localhost:8080\n"

# ── Producción ─────────────────────────────────────────────
prod-up: ## Levanta producción
	$(COMPOSE_PROD) up -d

prod-down: ## Detiene producción
	$(COMPOSE_PROD) down

prod-build: ## Reconstruye imágenes de producción
	$(COMPOSE_PROD) build --no-cache
