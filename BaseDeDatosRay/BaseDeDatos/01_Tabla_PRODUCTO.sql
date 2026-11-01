-- Sprint 1: CRUD de Productos
-- Raymel Alexander Ramirez Sandoval | Matrícula: 2025-1970
USE CatalogoCementeraDB;
GO
-- Ejecutar una vez. No elimina ni reemplaza tablas existentes.
CREATE TABLE dbo.PRODUCTO
(
    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_PRODUCTO PRIMARY KEY,
    Nombre NVARCHAR(150) NOT NULL,
    Precio DECIMAL(18,2) NOT NULL,
    Stock INT NOT NULL,
    CONSTRAINT CK_PRODUCTO_Nombre CHECK (LEN(LTRIM(RTRIM(Nombre))) > 0),
    CONSTRAINT CK_PRODUCTO_Precio CHECK (Precio >= 0),
    CONSTRAINT CK_PRODUCTO_Stock CHECK (Stock >= 0)
);
GO
