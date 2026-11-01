-- Sprint 1: CRUD de Productos
-- Raymel Alexander Ramirez Sandoval | Matrícula: 2025-1970
-- Preparación opcional. Ejecutar solo si no existe una BD acordada por el equipo.
USE master;
GO
IF DB_ID(N'CatalogoCementeraDB') IS NULL
    EXEC(N'CREATE DATABASE CatalogoCementeraDB');
GO
