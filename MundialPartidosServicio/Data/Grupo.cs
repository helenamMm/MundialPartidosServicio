using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MundialPartidosServicio.Data
{
    public class Grupo
    {
        [Key]
        [Column("id_grupo")]
        public int Id { get; set; } 
        [Column("letra_grupo")]
        public string? LetraGrupo { get; set; } 
        [Column("fecha_creacion")]
        public DateTime? FechaCreacion { get; set; } 
    }
}