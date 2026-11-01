-- Sprint 1: CRUD de Productos
-- Raymel Alexander Ramirez Sandoval | Matrícula: 2025-1970
USE CatalogoCementeraDB;
GO
CREATE OR ALTER PROCEDURE dbo.sp_CrearProducto
    @Nombre NVARCHAR(MAX),
    @Precio DECIMAL(18,2),
    @Stock INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    IF @Nombre IS NULL OR LEN(LTRIM(RTRIM(@Nombre))) = 0
        THROW 50001, N'El nombre es obligatorio.', 1;
    IF DATALENGTH(LTRIM(RTRIM(@Nombre))) > 300
        THROW 50002, N'El nombre no puede superar 150 unidades UTF-16.', 1;
    IF @Precio IS NULL OR @Precio < 0
        THROW 50003, N'El precio es obligatorio y no puede ser negativo.', 1;
    IF @Stock IS NULL OR @Stock < 0
        THROW 50004, N'El stock es obligatorio y no puede ser negativo.', 1;
    INSERT INTO dbo.PRODUCTO (Nombre, Precio, Stock)
    VALUES (LTRIM(RTRIM(@Nombre)), @Precio, @Stock);
    SELECT CONVERT(INT, SCOPE_IDENTITY()) AS Id;
END;
GO
