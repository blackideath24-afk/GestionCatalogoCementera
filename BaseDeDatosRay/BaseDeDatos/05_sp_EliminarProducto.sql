-- Sprint 1: CRUD de Productos
-- Raymel Alexander Ramirez Sandoval | Matrícula: 2025-1970
USE CatalogoCementeraDB;
GO
-- La confirmación del usuario corresponde al formulario, antes de llamar este SP.
CREATE OR ALTER PROCEDURE dbo.sp_EliminarProducto
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    IF @Id IS NULL OR @Id <= 0
        THROW 50005, N'Debe seleccionar un producto válido.', 1;
    DELETE FROM dbo.PRODUCTO WHERE Id = @Id;
    IF @@ROWCOUNT = 0
        THROW 50006, N'El producto indicado no existe.', 1;
    SELECT @Id AS Id;
END;
GO
