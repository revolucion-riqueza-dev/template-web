## ¿Qué cambia?

**Tipo de cambio**

- [ ] Feature nueva (backend y/o frontend)
- [ ] Corrección de error (bug fix)
- [ ] Refactor (sin cambio de comportamiento)
- [ ] Tests nuevos o actualizados
- [ ] Documento nuevo o actualización de documento (`docs/`)
- [ ] Configuración de Docker, Nginx o variables de entorno
- [ ] CI/CD (`.github/workflows/`)
- [ ] Dependencia nueva o actualizada (`composer.json` / `package.json`)
- [ ] Otro

**Descripción breve**

<!-- Explica qué hace este PR y por qué. Una o dos oraciones son suficientes. -->

---

## Checklist

- [ ] El código fue probado localmente (`make up` + flujo manual o tests)
- [ ] Los tests pasan (`make test-be` y/o `make test-fe`)
- [ ] Si se agregaron migraciones, se probaron con `make fresh`
- [ ] Si se modificó el backend, se respeta la separación de capas (Domain → Application → Infrastructure → Presentation)
- [ ] Si se agregaron variables de entorno, se actualizó el `.env.example` correspondiente
- [ ] Si se modificó Docker o Nginx, el entorno levanta sin errores con `make up`
- [ ] El CHANGELOG.md fue actualizado con una línea describiendo el cambio

---

## ¿Cómo probarlo?

<!-- Pasos para que el revisor pueda verificar el cambio. Omitir si es obvio. -->

1. 
2.