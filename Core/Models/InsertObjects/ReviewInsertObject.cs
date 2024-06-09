using System.ComponentModel.DataAnnotations;

public class ReviewUpsertObject
{
    [Required]
    [Range(1, 5, ErrorMessage = "Value must be between 1 and 5")]
    public int Rating { get; set; }

    [Required]
    [MinLength(2, ErrorMessage = "Comment must be at least 2 characters  long")]
    public string Comment { get; set; }

    [Required]
    public int ClientId { get; set; }

    [Required]
    public int BarberId { get; set; }
}