using System.ComponentModel.DataAnnotations;

namespace Core.Models.UpsertObjects
{
    public class ProductUpsertObject
    {
        [Required]
        public string Name { get; set; }

        [Required]
        public string Description { get; set; }

        [Required]
        [Range(0.1, double.MaxValue, ErrorMessage = "Price must be greater than zero")]
        [RegularExpression(@"^\$?([0-9]{1,3},([0-9]{3},)*[0-9]{3}|[0-9]+)(.[0-9][0-9])?$",
            ErrorMessage = "Price must be a decimal (e.g 20.30)")]
        public decimal Price { get; set; }

        [Required]
        public int ProductTypeId { get; set; }

        [Required]
        public int ProductBrandId { get; set; }
    }
}