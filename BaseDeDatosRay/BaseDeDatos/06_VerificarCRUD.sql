-- Sprint 1: CRUD de Productos
-- Raymel Alexander Ramirez Sandoval | Matrícula: 2025-1970
USE CatalogoCementeraDB;
GO
-- Ejecutar en una conexión sin transacciones abiertas. Usa ROLLBACK para no conservar datos.
-- Puede dejar saltos en IDENTITY; los identificadores no tienen que ser consecutivos.
SET NOCOUNT ON;
IF @@TRANCOUNT <> 0
    THROW 51000, N'Ejecute las pruebas sin una transacción abierta.', 1;
BEGIN TRY
    BEGIN TRANSACTION;
    DECLARE @Ids TABLE (Id INT);
    INSERT INTO @Ids EXEC dbo.sp_CrearProducto N'Cemento de prueba', 450.50, 10;
    DECLARE @Id INT = (SELECT Id FROM @Ids);
    IF @Id IS NULL OR NOT EXISTS
        (SELECT 1 FROM dbo.PRODUCTO WHERE Id=@Id AND Nombre=N'Cemento de prueba' AND Precio=450.50 AND Stock=10)
        THROW 51001, N'Falló la creación.', 1;
    DECLARE @Listado TABLE (Id INT, Nombre NVARCHAR(150), Precio DECIMAL(18,2), Stock INT);
    INSERT INTO @Listado EXEC dbo.sp_LeerProducto;
    IF NOT EXISTS (SELECT 1 FROM @Listado WHERE Id=@Id)
        THROW 51002, N'Falló la lectura.', 1;
    EXEC dbo.sp_ActualizarProducto @Id, N'Cemento actualizado', 500.00, 8;
    IF NOT EXISTS (SELECT 1 FROM dbo.PRODUCTO WHERE Id=@Id AND Nombre=N'Cemento actualizado' AND Precio=500 AND Stock=8)
        THROW 51003, N'Falló la actualización.', 1;
    EXEC dbo.sp_EliminarProducto @Id;
    IF EXISTS (SELECT 1 FROM dbo.PRODUCTO WHERE Id=@Id)
        THROW 51004, N'Falló la eliminación.', 1;
    ROLLBACK TRANSACTION;
    PRINT N'CORRECTO: crear, leer, actualizar y eliminar. Datos de prueba revertidos.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
-- Cada caso inválido usa una transacción propia: XACT_ABORT puede invalidarla.
BEGIN TRY
    BEGIN TRANSACTION;
    EXEC dbo.sp_CrearProducto N'   ', 1, 1;
    ROLLBACK TRANSACTION;
    THROW 51999, N'Falló validación: nombre vacío.', 1;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    IF ERROR_NUMBER() <> 50001 THROW;
    PRINT N'CORRECTO: nombre vacío rechazado.';
END CATCH;
GO
BEGIN TRY
    BEGIN TRANSACTION;
    DECLARE @L NVARCHAR(MAX)=REPLICATE(N'a',151); EXEC dbo.sp_CrearProducto @L, 1, 1;
    ROLLBACK TRANSACTION;
    THROW 51999, N'Falló validación: nombre largo.', 1;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    IF ERROR_NUMBER() <> 50002 THROW;
    PRINT N'CORRECTO: nombre largo rechazado.';
END CATCH;
GO
BEGIN TRY
    BEGIN TRANSACTION;
    EXEC dbo.sp_CrearProducto N'Prueba', -1, 1;
    ROLLBACK TRANSACTION;
    THROW 51999, N'Falló validación: precio negativo.', 1;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    IF ERROR_NUMBER() <> 50003 THROW;
    PRINT N'CORRECTO: precio negativo rechazado.';
END CATCH;
GO
BEGIN TRY
    BEGIN TRANSACTION;
    EXEC dbo.sp_CrearProducto N'Prueba', 1, -1;
    ROLLBACK TRANSACTION;
    THROW 51999, N'Falló validación: stock negativo.', 1;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    IF ERROR_NUMBER() <> 50004 THROW;
    PRINT N'CORRECTO: stock negativo rechazado.';
END CATCH;
GO
BEGIN TRY
    BEGIN TRANSACTION;
    EXEC dbo.sp_CrearProducto N'Prueba', NULL, 1;
    ROLLBACK TRANSACTION;
    THROW 51999, N'Falló validación: precio nulo.', 1;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    IF ERROR_NUMBER() <> 50003 THROW;
    PRINT N'CORRECTO: precio nulo rechazado.';
END CATCH;
GO
BEGIN TRY
    BEGIN TRANSACTION;
    EXEC dbo.sp_ActualizarProducto 0, N'Prueba', 1, 1;
    ROLLBACK TRANSACTION;
    THROW 51999, N'Falló validación: ID inválido al actualizar.', 1;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    IF ERROR_NUMBER() <> 50005 THROW;
    PRINT N'CORRECTO: ID inválido al actualizar rechazado.';
END CATCH;
GO
BEGIN TRY
    BEGIN TRANSACTION;
    EXEC dbo.sp_EliminarProducto NULL;
    ROLLBACK TRANSACTION;
    THROW 51999, N'Falló validación: ID inválido al eliminar.', 1;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    IF ERROR_NUMBER() <> 50005 THROW;
    PRINT N'CORRECTO: ID inválido al eliminar rechazado.';
END CATCH;
GO
