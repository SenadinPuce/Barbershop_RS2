using System.ComponentModel.DataAnnotations;

namespace Core.Models.UpdateObjects
{
    public class AppointmentUpdateObject
    {
        [Required]
        public bool IsCanceled { get; set; }
    }
}