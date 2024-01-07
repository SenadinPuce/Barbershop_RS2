using System.ComponentModel.DataAnnotations;

namespace Core.Models.InsertObjects
{
    public class OrderItemInsertObject
    {
        [Required]
        public int Id { get; set; }
        [Required]
        public int Quantity { get; set; }
    }
}