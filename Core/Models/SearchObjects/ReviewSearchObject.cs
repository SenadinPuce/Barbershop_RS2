using System.ComponentModel.DataAnnotations;

namespace Core.Models.SearchObjects
{
    public class ReviewSearchObject : BaseSearchObject
    {
        [Required]
        public int BarberId { get; set; }
        public bool IncludeClient { get; set; } = true;
    }
}