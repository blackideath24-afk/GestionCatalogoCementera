using Microsoft.Data.SqlClient;
using System.Data;

namespace GestionCatalogoCementera.Data
{
    // TAREA 22 (Osias): Clase de conexión a SQL Server y enlace con los 4 Stored Procedures
    public class ConexionBD
    {
        private readonly string _connectionString;

        public ConexionBD(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection")
                ?? "Server=localhost;Database=CatalogoCementeraDB;Trusted_Connection=True;TrustServerCertificate=True;";
        }

        // Abre y devuelve la conexión a SQL Server
        public SqlConnection CrearConexion()
        {
            return new SqlConnection(_connectionString);
        }

        // Enlace con sp_LeerProducto (HU-2)
        public SqlCommand ComandoLeerProductos(SqlConnection conn)
        {
            return new SqlCommand("sp_LeerProducto", conn)
            {
                CommandType = CommandType.StoredProcedure
            };
        }

        // Enlace con sp_CrearProducto (HU-1)
        public SqlCommand ComandoCrearProducto(SqlConnection conn, string nombre, decimal precio, int stock)
        {
            SqlCommand cmd = new SqlCommand("sp_CrearProducto", conn)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Nombre", nombre);
            cmd.Parameters.AddWithValue("@Precio", precio);
            cmd.Parameters.AddWithValue("@Stock", stock);
            return cmd;
        }

        // Enlace con sp_ActualizarProducto (HU-3)
        public SqlCommand ComandoActualizarProducto(SqlConnection conn, int id, string nombre, decimal precio, int stock)
        {
            SqlCommand cmd = new SqlCommand("sp_ActualizarProducto", conn)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Id", id);
            cmd.Parameters.AddWithValue("@Nombre", nombre);
            cmd.Parameters.AddWithValue("@Precio", precio);
            cmd.Parameters.AddWithValue("@Stock", stock);
            return cmd;
        }

        // Enlace con sp_EliminarProducto (HU-4)
        public SqlCommand ComandoEliminarProducto(SqlConnection conn, int id)
        {
            SqlCommand cmd = new SqlCommand("sp_EliminarProducto", conn)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Id", id);
            return cmd;
        }
    }
}