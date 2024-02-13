using System.ComponentModel.DataAnnotations;

namespace Core.Models.UpdateObjects
{
    public class NewsUpdateObject
    {
        [Required]
        public string Title { get; set; }

        [Required]
        public string Content { get; set; }

        [Required]
        public string Photo { get; set; }

        [Required]
        public DateTime CreatedDateTime { get; set; } = DateTime.UtcNow;
    }
}