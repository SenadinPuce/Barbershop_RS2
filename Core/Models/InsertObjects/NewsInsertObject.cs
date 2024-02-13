using System.ComponentModel.DataAnnotations;

namespace Core.Models.InsertObjects
{
    public class NewsInsertObject
    {
        [Required]
        public string Title { get; set; }

        [Required]
        public string Content { get; set; }

        [Required]
        public string Photo { get; set; }

        [Required]
        public DateTime CreatedDateTime { get; set; } = DateTime.UtcNow;

        [Required]
        public int AuthorId { get; set; }
    }
}