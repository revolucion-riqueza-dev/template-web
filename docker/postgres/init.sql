-- ============================================================
--  PostgreSQL — Script de inicialización
--  Se ejecuta una sola vez cuando el contenedor es creado.
-- ============================================================

-- Extensiones útiles
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";   -- UUIDs
CREATE EXTENSION IF NOT EXISTS "pgcrypto";    -- Funciones criptográficas
CREATE EXTENSION IF NOT EXISTS "unaccent";    -- Búsquedas sin tildes

-- Zona horaria por defecto
SET timezone = 'America/Bogota';

-- Agrega aquí cualquier setup inicial:
-- CREATE SCHEMA IF NOT EXISTS audit;
-- GRANT ALL PRIVILEGES ON DATABASE app_db TO app_user;
