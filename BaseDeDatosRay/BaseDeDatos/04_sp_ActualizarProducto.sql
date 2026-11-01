-- Sprint 1: CRUD de Productos
-- Raymel Alexander Ramirez Sandoval | Matrícula: 2025-1970
USE CatalogoCementeraDB;
GO
CREATE OR ALTER PROCEDURE dbo.sp_ActualizarProducto
    @Id INT,
    @Nombre NVARCHAR(MAX),
    @Precio DECIMAL(18,2),
    @Stock INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    IF @Id IS NULL OR @Id <= 0
        THROW 50005, N'Debe seleccionar un producto válido.', 1;
    IF @Nombre IS NULL OR LEN(LTRIM(RTRIM(@Nombre))) = 0
        THROW 50001, N'El nombre es obligatorio.', 1;
    IF DATALENGTH(LTRIM(RTRIM(@Nombre))) > 300
        THROW 50002, N'El nombre no puede superar 150 unidades UTF-16.', 1;
    IF @Precio IS NULL OR @Precio < 0
        THROW 50003, N'El precio es obligatorio y no puede ser negativo.', 1;
    IF @Stock IS NULL OR @Stock < 0
        THROW 50004, N'El stock es obligatorio y no puede ser negativo.', 1;
    UPDATE dbo.PRODUCTO
    SET Nombre = LTRIM(RTRIM(@Nombre)), Precio = @Precio, Stock = @Stock
    WHERE Id = @Id;
    IF @@ROWCOUNT = 0
        THROW 50006, N'El producto indicado no existe.', 1;
    SELECT @Id AS Id;
END;
GO
