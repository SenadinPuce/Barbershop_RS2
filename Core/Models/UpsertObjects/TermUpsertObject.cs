using System.ComponentModel.DataAnnotations;

namespace Core.Models.UpsertObjects
{
    public class TermUpsertObject
    {
        [Required]
        public int BarberId { get; set; }

        [Required]
        public DateTime Date { get; set; }

        [Required]
        public TimeSpan StartTime { get; set; }

        [Required]
        public TimeSpan EndTime { get; set; }
    }
}