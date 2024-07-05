using System.ComponentModel.DataAnnotations;

namespace Core.Models.InsertObjects
{
    public class AppointmentInsertObject
    {
        [Required]
        public int ClientId { get; set; }

        [Required]
        public int TermId { get; set; }

        [Required]
        public int ServiceId { get; set; }
    }
}