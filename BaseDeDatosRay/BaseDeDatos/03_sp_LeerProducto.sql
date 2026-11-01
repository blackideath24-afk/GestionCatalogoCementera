-- Sprint 1: CRUD de Productos
-- Raymel Alexander Ramirez Sandoval | Matrícula: 2025-1970
USE CatalogoCementeraDB;
GO
CREATE OR ALTER PROCEDURE dbo.sp_LeerProducto
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Nombre, Precio, Stock
    FROM dbo.PRODUCTO
    ORDER BY Id;
END;
GO
