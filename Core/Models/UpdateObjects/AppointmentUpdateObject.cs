using System.ComponentModel.DataAnnotations;

namespace Core.Models.UpdateObjects
{
    public class AppointmentUpdateObject
    {
        [Required]
        public int ClientId { get; set; }

        [Required]
        public int ServiceId { get; set; }
    }
}