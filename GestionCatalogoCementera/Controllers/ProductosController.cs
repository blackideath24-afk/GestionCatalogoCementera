using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Data;

namespace GestionCatalogoCementera.Controllers
{
    public class ProductoDto
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public decimal Precio { get; set; }
        public int Stock { get; set; }
    }

    [ApiController]
    [Route("api/productos")]
    public class ProductosController : ControllerBase
    {
        private readonly string _connectionString;

        public ProductosController(IConfiguration configuration)
        {
            var configConn = configuration.GetConnectionString("DefaultConnection");
            _connectionString = !string.IsNullOrWhiteSpace(configConn)
                ? configConn
                : "Server=localhost;Database=CatalogoCementeraDB;Trusted_Connection=True;TrustServerCertificate=True;";
        }

        [HttpGet]
        public IActionResult LeerProductos()
        {
            try
            {
                var lista = new List<ProductoDto>();
                using SqlConnection conn = new SqlConnection(_connectionString);
                using SqlCommand cmd = new SqlCommand("sp_LeerProducto", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                conn.Open();
                using SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    lista.Add(new ProductoDto
                    {
                        Id = Convert.ToInt32(reader["Id"]),
                        Nombre = reader["Nombre"].ToString() ?? "",
                        Precio = Convert.ToDecimal(reader["Precio"]),
                        Stock = Convert.ToInt32(reader["Stock"])
                    });
                }
                return Ok(lista);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPost]
        public IActionResult CrearProducto([FromBody] ProductoDto prod)
        {
            if (string.IsNullOrWhiteSpace(prod.Nombre) || prod.Precio < 0 || prod.Stock < 0)
                return BadRequest("Datos invalidos.");

            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                using SqlCommand cmd = new SqlCommand("sp_CrearProducto", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.AddWithValue("@Nombre", prod.Nombre.Trim());
                cmd.Parameters.AddWithValue("@Precio", prod.Precio);
                cmd.Parameters.AddWithValue("@Stock", prod.Stock);

                conn.Open();
                cmd.ExecuteNonQuery();
                return Ok(new { mensaje = "Creado" });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPut("{id}")]
        public IActionResult ActualizarProducto(int id, [FromBody] ProductoDto prod)
        {
            if (id <= 0 || string.IsNullOrWhiteSpace(prod.Nombre) || prod.Precio < 0 || prod.Stock < 0)
                return BadRequest("Datos invalidos.");

            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                using SqlCommand cmd = new SqlCommand("sp_ActualizarProducto", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.AddWithValue("@Id", id);
                cmd.Parameters.AddWithValue("@Nombre", prod.Nombre.Trim());
                cmd.Parameters.AddWithValue("@Precio", prod.Precio);
                cmd.Parameters.AddWithValue("@Stock", prod.Stock);

                conn.Open();
                cmd.ExecuteNonQuery();
                return Ok(new { mensaje = "Actualizado" });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpDelete("{id}")]
        public IActionResult EliminarProducto(int id)
        {
            if (id <= 0)
                return BadRequest("ID invalido.");

            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                using SqlCommand cmd = new SqlCommand("sp_EliminarProducto", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.AddWithValue("@Id", id);

                conn.Open();
                cmd.ExecuteNonQuery();
                return Ok(new { mensaje = "Eliminado" });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}