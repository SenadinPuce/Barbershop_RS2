using System.ComponentModel.DataAnnotations;

namespace Core.Models.UpsertObjects
{
  public class ServiceUpsertObject
  {
    [Required]
    [MinLength(2, ErrorMessage = "Name of barber service must have at least 2 characters")]
    public string Name { get; set; }

    [Required]
    public string Description { get; set; }

    [Required]
    [Range(0.1, double.MaxValue, ErrorMessage = "Price must be greater than zero")]

    public decimal Price { get; set; }
  }
}