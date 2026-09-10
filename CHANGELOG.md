# Changelog - Template Web



## [2026-09-10]

---
- fix: Dockerfile.dev ya no requiere package-lock.json en el COPY
- fix: ESLint ignora next-env.d.ts y .next/** para evitar errores en CI con Next.js 15
- feat: Nginx agrega ruta /docs para servir assets de Swagger UI
- feat: make install instala darkaonline/l5-swagger, publica assets y genera documentacion inicial
- feat: make setup ejecuta setup.sh para la configuracion inicial del proyecto
- feat: setup.sh automatiza la creacion del proyecto Laravel, copia de capas, limpieza de archivos y configuracion de PostgreSQL
- feat: ApiDocController.php con OA\Info y health-check usando atributos PHP 8
- feat: DatabaseSeeder.php vacio para evitar errores en make fresh


## [2026-09-08]

---
- Creación Inicial de la template
...