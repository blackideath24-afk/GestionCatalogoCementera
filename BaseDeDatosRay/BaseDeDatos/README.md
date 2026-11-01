# Base de datos del catálogo cementero

**Autor:** Raymel Alexander Ramirez Sandoval  
**Matrícula:** 2025-1970  
**Rol:** Persona 3, base de datos.  
**Integración:** repositorio GestionCatalogoCementera, versión del ZIP facilitado por el equipo.

## Instalación

1. Conectarse desde SQL Server Management Studio a la instancia usada por la aplicación.
2. Ejecutar `00_CrearBaseDeDatos.sql` para crear `CatalogoCementeraDB` si falta (requiere permiso de creación). Si ya existe, el script la conserva.
3. Ejecutar los archivos `01` a `05`, en orden. `01` se ejecuta una sola vez: si PRODUCTO ya existe, revisar su estructura antes de continuar. No borrar una tabla existente para instalar estos archivos. `02` a `05` crean o actualizan los procedimientos.
4. Ejecutar `06_VerificarCRUD.sql` y comprobar los mensajes CORRECTO. Las operaciones válidas de prueba se revierten; pueden quedar saltos en los identificadores autoincrementales.
5. Iniciar el proyecto ASP.NET Core y probar crear, consultar, actualizar y eliminar desde su página principal.

Requiere SQL Server 2016 SP1 o posterior por CREATE OR ALTER. Ejecutar los scripts con SSMS o sqlcmd, que reconocen los separadores GO.

## Conexión que utiliza el repositorio

`GestionCatalogoCementera/appsettings.json`, clave `ConnectionStrings:DefaultConnection`:

```text
Server=localhost;Database=CatalogoCementeraDB;Trusted_Connection=True;TrustServerCertificate=True;
```

Los scripts usan exactamente esa base de datos. `localhost` corresponde a la instancia predeterminada del equipo que ejecuta la aplicación. Si SQL Server está en una instancia con nombre, ajustar Server en la configuración local, por ejemplo `localhost\SQLEXPRESS` (en JSON la barra debe escribirse doble). La cuenta de Windows que ejecuta la aplicación necesita acceso a la BD y permiso para ejecutar los procedimientos. No incluir credenciales en GitHub.

## Entregas individuales

Los números de tarea corresponden a «Historias y tareas»; no son números de issue confirmados de GitHub/Jira.

| Tarea | Historia | Archivo | Equivalencia en la guía |
|---|---|---|---|
| 1: tabla PRODUCTO | GC-2 / HU-1 | 01_Tabla_PRODUCTO.sql | T-01 |
| 2: registrar | GC-2 / HU-1 | 02_sp_CrearProducto.sql | T-02 |
| 7: consultar | GC-3 / HU-2 | 03_sp_LeerProducto.sql | T-06 |
| 12: actualizar | GC-4 / HU-3 | 04_sp_ActualizarProducto.sql | T-10 |
| 17: eliminar | GC-5 / HU-4 | 05_sp_EliminarProducto.sql | T-14 |
| 25: entregar scripts a Adonis | Transversal | Toda esta carpeta | T-22 |

El contrato de integración es además un aporte a la tarea 21 de Albert (planificación técnica).

## Modelo

- `dbo.PRODUCTO.Id`: INT IDENTITY(1,1), clave primaria.
- `Nombre`: NVARCHAR(150), obligatorio; no admite vacío ni solo espacios ordinarios.
- `Precio`: DECIMAL(18,2), obligatorio, mayor o igual a cero.
- `Stock`: INT, obligatorio, mayor o igual a cero.

Se permite repetir nombres porque las historias no exigen unicidad. Los SP recortan espacios ordinarios de los extremos. No se agregan campos ni otras tablas. La eliminación es física conforme a los criterios de aceptación. Las restricciones también protegen frente a escrituras directas con valores inválidos.

## Verificación y evidencias

Se cotejaron los nombres de SP, parámetros y columnas con `ProductosController.cs` y `Data/ConexionBD.cs`; coinciden. Se comprobó que el código original del ZIP permanece idéntico. La API usa ExecuteNonQuery para las escrituras e ignora su valor devuelto, por lo que es compatible con SET NOCOUNT ON y los Id devueltos por estos SP.

**Pendiente de ejecución real:** no fue posible conectar con SQL Server en localhost desde el entorno de preparación. No se afirma que las pruebas SQL ni las pruebas de extremo a extremo hayan pasado. Ejecutar 06 en la instancia del equipo y conservar los resultados reales.

Capturar: estructura de tabla; registro creado; listado; mismo Id con precio/stock modificados; producto de prueba eliminado; mensajes de las pruebas. No usar el catálogo real para pruebas destructivas. No inventar fechas, story points o evidencias.

## Diferencia con la guía

El repositorio recibido es una aplicación web ASP.NET Core net8.0 con HTML/JavaScript; la guía menciona Windows Forms. Esta entrega de BD se adapta al repositorio recibido. El equipo debe confirmar el formato del incremento con el profesor; agregar los scripts no resuelve esa diferencia.
