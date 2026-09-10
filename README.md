# [CÓDIGO-PROYECTO] | [Nombre del Proyecto Web]

| Campo | Valor |
|---|---|
| **Programa / Área** | [Área] |
| **Responsable** | [Nombre] |
| **Estado** | En desarrollo |
| **Creado** | [YYYY-MM-DD] |

---

## ¿Qué es este proyecto?

[Descripción corta del proyecto]

---

## Stack tecnológico

| Capa | Tecnología | Notas |
|---|---|---|
| Frontend | Next.js 15 · React 19 · TypeScript | App Router · Tailwind CSS v3 |
| Backend | Laravel 12 · PHP 8.4 | API REST · Laravel Sanctum |
| Base de datos | PostgreSQL 16 | |
| Cache / Colas | Redis 7 | |
| Proxy | Nginx 1.25 | |
| Contenedores | Docker · Docker Compose | Dev y producción |

---

## Contenido del repositorio

| Carpeta / Archivo | Contenido |
|---|---|
| `frontend/` | Código del cliente (Next.js) |
| `frontend/src/domain/` | Entidades e interfaces del dominio |
| `frontend/src/application/` | Casos de uso |
| `frontend/src/infrastructure/` | HTTP client, repositorios API |
| `frontend/src/presentation/` | Componentes, hooks, providers |
| `frontend/src/shared/` | Utils, constantes y tipos globales |
| `frontend/src/app/` | Páginas y layouts (App Router) |
| `backend/` | Proyecto Laravel + capas de Clean Architecture |
| `backend/app/Domain/` | Entidades, interfaces, value objects |
| `backend/app/Application/` | Casos de uso y DTOs |
| `backend/app/Infrastructure/` | Repositorios Eloquent y providers |
| `backend/app/Presentation/` | Controllers, Requests, Resources |
| `docker/nginx/` | Configuración de Nginx (dev y prod) |
| `docker/php/` | Configuración de PHP y Xdebug |
| `docker/postgres/` | Script de inicialización de BD |
| `docker-compose.dev.yml` | Entorno de desarrollo local |
| `docker-compose.yml` | Entorno de producción |
| `Makefile` | Comandos del proyecto (`make up`, `make migrate`...) |
| `docs/requerimientos/` | Documentos LRQ del proyecto |
| `docs/documentacion-tecnica/` | Documentos DTE del proyecto |
| `docs/arquitectura/` | Diagramas y decisiones de arquitectura |

---

## Requisitos previos

Antes de empezar, asegúrate de tener instalado lo siguiente en tu máquina:

| Herramienta | Para qué se usa | Cómo verificar |
|---|---|---|
| [Docker Desktop](https://www.docker.com/products/docker-desktop/) | Correr todos los servicios (PHP, Node, PostgreSQL, Nginx) | `docker --version` |
| [Git](https://git-scm.com/) | Control de versiones | `git --version` |
| [PHP 8.4](https://www.php.net/downloads) | Solo para el script de configuración inicial | `php --version` |
| [Composer](https://getcomposer.org/) | Gestor de dependencias de PHP | `composer --version` |
| [Node.js 20+](https://nodejs.org/) | Solo si quieres correr el frontend sin Docker | `node --version` |
| `make` | Ejecutar los comandos del proyecto | `make --version` |

> **Nota:** Una vez que el proyecto esté corriendo con Docker, solo necesitas Docker y Git para el día a día. PHP y Composer solo se necesitan para el script de configuración inicial.

### Instalación en Windows (paso a paso)

En macOS y Linux las herramientas del sistema ya vienen instaladas o se instalan fácilmente. En **Windows** sigue este orden:

**1. Instalar Chocolatey** (gestor de paquetes — abre PowerShell como Administrador):

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Cierra y vuelve a abrir PowerShell como Administrador.

**2. Instalar PHP 8.4, Composer, Node y make:**

> ⚠️ No uses `choco install php` sin versión — instala la última disponible (puede ser 8.5 o superior). Especifica siempre la versión 8.4:

```powershell
choco install php --version=8.4.25 -y
choco install composer nodejs make -y
```

Cierra y vuelve a abrir PowerShell (para que el PATH se actualice).

**3. Instalar Docker Desktop:**

Descárgalo desde https://www.docker.com/products/docker-desktop/ e instálalo. Requiere reiniciar el equipo.

**4. Habilitar la extensión fileinfo en PHP (solo Windows)**

Antes de continuar, PHP necesita la extensión `fileinfo` activa. Abre el archivo `C:\tools\php84\php.ini` (o la ruta donde se instaló PHP), busca esta línea y quítale el punto y coma:

```ini
;extension=fileinfo   ← antes
extension=fileinfo    ← después
```

Guarda el archivo y cierra el editor. En macOS y Linux esta extensión ya viene habilitada.

**5. Verificar que todo quedó bien:**

```powershell
php --version       # PHP 8.4.x
composer --version
node --version
docker --version
make --version
```

Todos deben responder con su versión antes de continuar.

---

## Configuración inicial (primera vez)

Sigue estos pasos **en orden**. Solo se hacen una vez por proyecto.

> **Importante:** en Windows usa **Git Bash** (no PowerShell ni CMD) para ejecutar los comandos de esta sección.

### Paso 1 — Clonar el repositorio

```bash
git clone [URL-del-repositorio]
cd [nombre-del-repositorio]
```

### Paso 2 — Preparar el proyecto Laravel

La carpeta `backend/` de esta plantilla contiene las capas de Clean Architecture, pero **no** el proyecto Laravel completo. Este paso lo prepara.

#### Opción A — Script automático (recomendado)

```bash
bash setup.sh
```

El script hace automáticamente los Pasos 2a al 2f que se describen a continuación. Si funciona correctamente, salta directo al Paso 3.

#### Opción B — Manual (si el script falla)

##### Paso 2a — Crear el proyecto Laravel

> **Importante:** No uses `laravel new` directamente — instala la última versión disponible (puede ser 13 o superior). Usa `composer create-project` para fijar la versión 12.

```bash
# Desde la raíz del proyecto, renombra temporalmente la carpeta backend
mv backend backend-arch

# Crea el proyecto Laravel 12 (fija la versión con composer)
composer create-project laravel/laravel backend "^12.0"

# Copia las capas de Clean Architecture dentro del proyecto Laravel recién creado
cp -r backend-arch/app/Domain         backend/app/
cp -r backend-arch/app/Application    backend/app/
cp -r backend-arch/app/Infrastructure backend/app/
cp -r backend-arch/app/Presentation   backend/app/

# Copia también los Dockerfiles y el .env.example
cp backend-arch/Dockerfile     backend/Dockerfile
cp backend-arch/Dockerfile.dev backend/Dockerfile.dev
cp backend-arch/.env.example   backend/.env.example

# Copia el seeder vacío (reemplaza el seeder por defecto de Laravel)
cp backend-arch/database/seeders/DatabaseSeeder.php backend/database/seeders/DatabaseSeeder.php

# Elimina la carpeta temporal
rm -rf backend-arch
# Windows (PowerShell): Remove-Item -Recurse -Force backend-arch
```

##### Paso 2b — Limpiar archivos de frontend de Laravel

Laravel genera archivos de Vite y frontend que no se usan porque el frontend es Next.js. Elimínalos desde la carpeta `backend/`:

```bash
rm -rf resources package.json vite.config.js
```

##### Paso 2c — Eliminar las migraciones por defecto de Laravel

Laravel genera tres migraciones iniciales que no corresponden a tu dominio. Elimínalas desde la carpeta `backend/`:

```bash
rm database/migrations/0001_01_01_000000_create_users_table.php
rm database/migrations/0001_01_01_000001_create_cache_table.php
rm database/migrations/0001_01_01_000002_create_jobs_table.php
```

> Estas migraciones crean tablas genéricas (`users`, `cache`, `jobs`). En Clean Architecture las migraciones se crean a mano siguiendo las entidades del dominio del proyecto.

> Si copiaste el `DatabaseSeeder.php` desde la plantilla en el Paso 2a, el seeder ya está vacío. Si no, abre `backend/database/seeders/DatabaseSeeder.php` y deja el método `run()` vacío para evitar errores en `make fresh`.

##### Paso 2d — Cambiar el motor de base de datos por defecto

Laravel usa SQLite como motor por defecto. Cámbialo a PostgreSQL en `backend/config/database.php`:

```php
// Antes:
'default' => env('DB_CONNECTION', 'sqlite'),

// Después:
'default' => env('DB_CONNECTION', 'pgsql'),
```

##### Paso 2e — Registrar el RepositoryServiceProvider en Laravel

Abre el archivo `backend/bootstrap/providers.php` y agrega el provider de la plantilla:

```php
return [
    App\Providers\AppServiceProvider::class,
    App\Infrastructure\Providers\RepositoryServiceProvider::class, // ← agregar esta línea
];
```

> Este archivo es el que Laravel usa para registrar todos los providers. El `RepositoryServiceProvider` es donde se conectan las interfaces del dominio con las implementaciones concretas de infraestructura.

### Paso 3 — Configurar las variables de entorno

```bash
cp .env.example .env
cp backend/.env.example backend/.env
cp frontend/.env.example frontend/.env.local
```

Abre cada archivo `.env` y ajusta los valores según tu entorno. Los más importantes son:

| Variable | Archivo | Valor para desarrollo local |
|---|---|---|
| `COMPOSE_PROJECT_NAME` | `.env` | El código del repositorio en minúsculas con guiones (ej: `cs-web-26-001-terminos-condiciones`). Docker lo usa como prefijo de los contenedores para que no se mezclen con otros proyectos. |
| `DB_DATABASE` | `.env` y `backend/.env` | El nombre que quieras darle a la BD (ej: `mi_proyecto_db`) |
| `DB_USERNAME` | `.env` y `backend/.env` | Usuario de PostgreSQL (ej: `postgres`) |
| `DB_PASSWORD` | `.env` y `backend/.env` | Contraseña que quieras (ej: `postgres`) |
| `APP_KEY` | `backend/.env` | Se genera automáticamente en el paso siguiente |
| `NEXT_PUBLIC_API_URL` | `frontend/.env.local` | `http://localhost:8080/api` (fijo, no cambiar en desarrollo local) |

> Los valores de `DB_DATABASE`, `DB_USERNAME` y `DB_PASSWORD` los inventas tú — Docker creará la base de datos con esas credenciales. Lo único importante es que sean iguales en `.env` y `backend/.env`.

### Paso 4 — Levantar el entorno con Docker

```bash
make install
```

Este comando hace todo lo siguiente automáticamente:
1. Construye las imágenes de Docker para PHP y Next.js
2. Levanta todos los contenedores (Nginx, Laravel, Next.js, PostgreSQL, Redis, Mailpit)
3. Instala las dependencias de Composer dentro del contenedor
4. Instala `darkaonline/l5-swagger` para la documentación de la API
5. Genera la `APP_KEY` de Laravel (`php artisan key:generate`)
6. Publica los assets de Swagger UI
7. Ejecuta las migraciones de la base de datos
8. Genera la documentación Swagger inicial
9. Instala las dependencias de npm dentro del contenedor

Cuando termine, verás:

```
  Instalacion completa. Accede en http://localhost:8080
  Swagger UI: http://localhost:8080/api/documentation
```

---

## Uso diario

Una vez que el proyecto ya fue instalado, estos son los únicos comandos que necesitas:

```bash
make up    # Levantar todos los servicios
make down  # Detener todos los servicios
make logs  # Ver logs en tiempo real (Ctrl+C para salir)
```

### URLs disponibles en desarrollo

| Servicio | URL | Descripción |
|---|---|---|
| Aplicación | http://localhost:3000 | Frontend Next.js (acceso directo) |
| Aplicación (via Nginx) | http://localhost:8080 | Frontend + API en el mismo puerto |
| API Laravel | http://localhost:8080/api | Endpoints del backend |
| Swagger UI | http://localhost:8080/api/documentation | Documentación interactiva de la API |
| Mailpit | http://localhost:8025 | Bandeja de entrada para emails de prueba |

### Otros comandos útiles

```bash
make shell-be                    # Abrir terminal dentro del contenedor backend
make shell-fe                    # Abrir terminal dentro del contenedor frontend
make shell-db                    # Abrir psql (consola de PostgreSQL)
make migrate                     # Ejecutar migraciones pendientes
make fresh                       # Borrar toda la BD y volver a migrar + seeders
make test-be                     # Correr tests PHP (PHPUnit)
make test-fe                     # Correr tests TypeScript (Jest)
make artisan CMD="route:list"    # Ejecutar cualquier comando de Artisan
```

---

## Variables de entorno

> Las variables de entorno **nunca** se suben al repositorio. El `.gitignore` ya está configurado para ignorar todos los archivos `.env`.

Hay tres archivos `.env` en el proyecto:

| Archivo | Usado por |
|---|---|
| `.env` | Docker Compose — define credenciales de BD y nombre del proyecto |
| `backend/.env` | Laravel — configuración completa de la app PHP |
| `frontend/.env.local` | Next.js — variables expuestas al cliente (prefijo `NEXT_PUBLIC_`) |

---

## Cómo trabajar en este repositorio

Seguir el flujo GitFlow definido en **MAN-DOC-003**:

```bash
# Partir siempre desde develop actualizado
git checkout develop
git pull origin develop

# Crear rama de trabajo
git checkout -b feat/nombre-del-cambio

# Commitear y abrir PR hacia develop
git push origin feat/nombre-del-cambio
```

> **Regla:** ningún cambio va directo a `main`. Todo pasa por Pull Request aprobado.

---

## Despliegue

El proyecto se despliega en un **VPS administrado con [EasyPanel](https://easypanel.io/)**.
EasyPanel gestiona los servicios como contenedores Docker, asigna los subdominios y emite los certificados SSL automáticamente via Let's Encrypt.

| Entorno | URL |
|---|---|
| Frontend | `https://[subdominio].dominio.com` |
| API Backend | `https://api.[subdominio].dominio.com` |

### Servicios en el VPS (EasyPanel)

| Servicio | Tipo en EasyPanel | Notas |
|---|---|---|
| Frontend (Next.js) | App | Imagen construida desde `frontend/Dockerfile` |
| Backend (Laravel) | App | Imagen construida desde `backend/Dockerfile` |
| PostgreSQL | Postgres | Base de datos gestionada por EasyPanel |
| Redis | Redis | Cache y colas gestionado por EasyPanel |

> PostgreSQL y Redis los provee EasyPanel directamente — no hace falta configurar esos contenedores a mano. EasyPanel entrega las credenciales de conexión como variables de entorno que se agregan a cada servicio.

### Pasos para desplegar en EasyPanel

**1. Crear el proyecto en EasyPanel**

En el panel del VPS, crear un nuevo proyecto con el nombre del proyecto (ej: `CS-WEB-26-001`).

**2. Agregar el servicio de Base de datos**

Dentro del proyecto en EasyPanel:
- Agregar servicio → **Postgres** → asignar nombre `db`
- EasyPanel genera automáticamente: host, puerto, usuario, contraseña y nombre de BD
- Copiar esas credenciales para usarlas en el siguiente paso

**3. Agregar Redis**

- Agregar servicio → **Redis** → asignar nombre `redis`
- EasyPanel entrega la URL de conexión (`REDIS_URL`)

**4. Agregar el servicio Backend (Laravel)**

- Agregar servicio → **App** → conectar el repositorio de GitHub
- Configurar:
  - **Dockerfile path:** `backend/Dockerfile`
  - **Dominio:** `api.[subdominio].dominio.com`
  - **Puerto:** `9000`
- En la sección de **Variables de entorno**, agregar:

```env
APP_ENV=production
APP_DEBUG=false
APP_KEY=[generada con php artisan key:generate]
APP_URL=https://api.[subdominio].dominio.com

DB_CONNECTION=pgsql
DB_HOST=[host entregado por EasyPanel Postgres]
DB_PORT=5432
DB_DATABASE=[nombre BD de EasyPanel]
DB_USERNAME=[usuario de EasyPanel]
DB_PASSWORD=[contraseña de EasyPanel]

REDIS_HOST=[host entregado por EasyPanel Redis]
REDIS_PORT=6379

CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis
```

**5. Agregar el servicio Frontend (Next.js)**

- Agregar servicio → **App** → conectar el mismo repositorio de GitHub
- Configurar:
  - **Dockerfile path:** `frontend/Dockerfile`
  - **Dominio:** `[subdominio].dominio.com`
  - **Puerto:** `3000`
- En la sección de **Variables de entorno**, agregar:

```env
NODE_ENV=production
NEXT_PUBLIC_API_URL=https://api.[subdominio].dominio.com/api
```

**6. Ejecutar migraciones**

Una vez que el servicio de backend esté corriendo, ejecutar las migraciones desde la terminal de EasyPanel o via SSH al VPS:

```bash
# Desde la consola del servicio backend en EasyPanel
php artisan migrate --force
```

**7. SSL**

EasyPanel gestiona los certificados SSL automáticamente. Al asignar el dominio a cada servicio, el certificado se emite y renueva sin intervención manual.

---

> Para más detalles del despliegue, ver el documento **DTE** correspondiente en `docs/documentacion-tecnica/`.