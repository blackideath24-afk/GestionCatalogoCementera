# Contrato SQL con la aplicación existente

Autor: Raymel Alexander Ramirez Sandoval — 2025-1970.

Base: **CatalogoCementeraDB**. Tabla: **dbo.PRODUCTO**.

| Ruta API | Procedimiento | Parámetros SQL | Uso actual en C# |
|---|---|---|---|
| GET /api/productos | dbo.sp_LeerProducto | Ninguno | ExecuteReader; lee Id, Nombre, Precio, Stock |
| POST /api/productos | dbo.sp_CrearProducto | @Nombre, @Precio, @Stock | ExecuteNonQuery |
| PUT /api/productos/{id} | dbo.sp_ActualizarProducto | @Id, @Nombre, @Precio, @Stock | ExecuteNonQuery |
| DELETE /api/productos/{id} | dbo.sp_EliminarProducto | @Id | ExecuteNonQuery |

Tipos: @Id INT, @Nombre NVARCHAR(MAX), @Precio DECIMAL(18,2), @Stock INT. Nombre se recibe como MAX para detectar exceso de longitud antes de insertarlo en NVARCHAR(150). El máximo es 150 unidades UTF-16. La lectura devuelve Id INT, Nombre NVARCHAR(150), Precio DECIMAL(18,2) y Stock INT, ordenados por Id.

Crear devuelve una fila con Id mediante SCOPE_IDENTITY. Actualizar y eliminar devuelven el Id afectado. El controlador actual no consume estos resultados; puede seguir usando ExecuteNonQuery sin cambios. No interpreta el número de filas afectadas, así que SET NOCOUNT ON no afecta su criterio de éxito. La API produce sus propios mensajes Creado, Actualizado y Eliminado.

Errores SQL: 50001 nombre requerido; 50002 nombre demasiado largo; 50003 precio inválido; 50004 stock inválido; 50005 Id inválido; 50006 producto inexistente. La API existente captura las excepciones y responde BadRequest. Los valores no numéricos se validan en la interfaz y en la deserialización de la API; SQL recibe parámetros tipados.

La confirmación de borrado y cancelación se resuelve en el modal de wwwroot/index.html. La página vuelve a consultar GET tras una escritura exitosa. Si la consulta no devuelve productos, muestra el catálogo vacío. Estas responsabilidades ya están en el frontend recibido.

El controlador crea sus comandos directamente. Data/ConexionBD.cs contiene métodos equivalentes, pero el controlador no los utiliza; ambos contratos son compatibles con estos scripts.

## Prueba manual de integración

1. Ejecutar scripts 00–05 y levantar la aplicación con la instancia SQL correcta.
2. Crear «Cemento prueba», precio 450.50 y stock 10: debe aparecer en el listado.
3. Seleccionar ese producto y actualizar precio a 500 y stock a 8.
4. Cancelar una eliminación: el producto debe permanecer.
5. Confirmar la eliminación: debe desaparecer del listado y de dbo.PRODUCTO.
6. Probar nombre vacío, precio negativo y stock negativo desde la interfaz; deben bloquearse.
7. Consultar SELECT Id, Nombre, Precio, Stock FROM dbo.PRODUCTO para cotejar persistencia durante cada paso.

Estas son instrucciones de prueba pendientes, no un informe de ejecución.
