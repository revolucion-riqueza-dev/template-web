# [CÓDIGO-PROYECTO] | [Nombre del Proyecto Web]

> ⚙️ **Instrucciones para usar esta plantilla:** Reemplaza todas las líneas entre corchetes `[...]` con la información real del proyecto, luego elimina este bloque de instrucciones antes del primer commit.

| Campo | Valor |
|---|---|
| **Programa / Área** | [Ej: Marketing / Desarrollo / Ventas] |
| **Responsable** | [Nombre del responsable] |
| **Estado** | En desarrollo |
| **Creado** | [AAAA-MM-DD] |

---

## ¿Qué es este proyecto?

[Descripción breve: qué construye, para quién es y cuál es el objetivo principal.]

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
| `docs/actas/` | Actas de Reunion |
| `docs/manuales/` | Manuales de Uso |

---

## Requisitos previos

Antes de empezar, asegúrate de tener instalado lo siguiente en tu máquina:

| Herramienta | Para qué se usa | Cómo verificar |
|---|---|---|
| [Docker Desktop](https://www.docker.com/products/docker-desktop/) | Correr todos los servicios (PHP, Node, PostgreSQL, Nginx) | `docker --version` |
| [Git](https://git-scm.com/) | Control de versiones | `git --version` |
| [PHP 8.4](https://www.php.net/downloads) | Solo para crear el proyecto Laravel inicial | `php --version` |
| [Composer](https://getcomposer.org/) | Gestor de dependencias de PHP | `composer --version` |
| [Laravel Installer](https://laravel.com/docs/12.x) | Crear el proyecto Laravel | `laravel --version` |
| [Node.js 20+](https://nodejs.org/) | Solo si quieres correr el frontend sin Docker | `node --version` |
| `make` | Ejecutar los comandos del proyecto | `make --version` |

> **Nota:** Una vez que el proyecto esté corriendo con Docker, solo necesitas Docker y Git para el día a día. PHP, Composer y Node solo se necesitan para el paso de instalación inicial.

### Instalación de `make` en Windows

En macOS y Linux `make` ya viene instalado. En **Windows** hay que instalarlo manualmente. La forma más sencilla es con [Chocolatey](https://chocolatey.org/install):

```powershell
# Abrir PowerShell como Administrador y ejecutar:
choco install make
```

Si no tienes Chocolatey instalado, primero ejecúta esto en PowerShell como Administrador:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Luego cierra y vuelve a abrir PowerShell, y ejecuta `choco install make`.

Verifica la instalación con `make --version`.

---

## Configuración inicial (primera vez)

Sigue estos pasos **en orden**. Solo se hacen una vez por proyecto.

### Paso 1 — Clonar el repositorio

```bash
git clone [URL-del-repo]
cd [nombre-del-repo]
```

### Paso 2 — Crear el proyecto Laravel

La carpeta `backend/` de esta plantilla contiene las capas de Clean Architecture, pero **no** el proyecto Laravel completo. Laravel se crea con su instalador oficial y luego se combina con la plantilla.

```bash
# Desde la raíz del proyecto, renombra temporalmente la carpeta backend
mv backend backend-arch

# Crea el proyecto Laravel (esto genera toda la estructura de Laravel)
laravel new backend --no-interaction --php=8.4

# Copia las capas de Clean Architecture dentro del proyecto Laravel recién creado
cp -r backend-arch/app/Domain       backend/app/
cp -r backend-arch/app/Application  backend/app/
cp -r backend-arch/app/Infrastructure backend/app/
cp -r backend-arch/app/Presentation  backend/app/

# Copia también los Dockerfiles y el .env.example
cp backend-arch/Dockerfile     backend/Dockerfile
cp backend-arch/Dockerfile.dev backend/Dockerfile.dev
cp backend-arch/.env.example   backend/.env.example

# Ya no necesitas la carpeta temporal
rm -rf backend-arch
```

### Paso 3 — Registrar el RepositoryServiceProvider en Laravel

Abre el archivo `backend/bootstrap/providers.php` y agrega el provider de la plantilla:

```php
return [
    App\Providers\AppServiceProvider::class,
    App\Infrastructure\Providers\RepositoryServiceProvider::class, // ← agregar esta línea
];
```

> Este archivo es el que Laravel usa para registrar todos los providers. El `RepositoryServiceProvider` es donde se conectan las interfaces del dominio con las implementaciones concretas de infraestructura.

### Paso 4 — Configurar las variables de entorno

```bash
# Variables raíz (usadas por Docker Compose)
cp .env.example .env

# Variables del backend (usadas por Laravel)
cp backend/.env.example backend/.env

# Variables del frontend (usadas por Next.js)
cp frontend/.env.example frontend/.env.local
```

Abre cada archivo `.env` y ajusta los valores según tu entorno. Los más importantes son:

| Variable | Archivo | Descripción |
|---|---|---|
| `DB_DATABASE` | `.env` y `backend/.env` | Nombre de la base de datos |
| `DB_USERNAME` | `.env` y `backend/.env` | Usuario de PostgreSQL |
| `DB_PASSWORD` | `.env` y `backend/.env` | Contraseña de PostgreSQL |
| `APP_KEY` | `backend/.env` | Se genera automáticamente en el paso siguiente |
| `NEXT_PUBLIC_API_URL` | `frontend/.env.local` | URL de la API Laravel |

### Paso 5 — Levantar el entorno con Docker

```bash
make install
```

Este comando hace todo lo siguiente automáticamente:
1. Construye las imágenes de Docker para PHP y Next.js
2. Levanta todos los contenedores (Nginx, Laravel, Next.js, PostgreSQL, Redis, Mailpit)
3. Instala las dependencias de Composer dentro del contenedor
4. Genera la `APP_KEY` de Laravel (`php artisan key:generate`)
5. Instala las dependencias de npm dentro del contenedor
6. Ejecuta las migraciones de la base de datos

Cuando termine, verás:

```
✅  Instalación completa. Accede en http://localhost:8080
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

En el panel del VPS, crear un nuevo proyecto con el nombre del proyecto (ej: `[CÓDIGO-PROYECTO]`).

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

> Para más detalles del despliegue, ver el documento **[DTE correspondiente]** en `docs/documentacion-tecnica/`.