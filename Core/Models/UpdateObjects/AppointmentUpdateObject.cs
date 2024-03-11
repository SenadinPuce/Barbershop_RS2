using System.ComponentModel.DataAnnotations;
using Core.Entities;

namespace Core.Models.UpdateObjects
{
    public class AppointmentUpdateObject
    {
        [Required]
        public int ClientId { get; set; }

        [Required]
        public int ServiceId { get; set; }
        
        public AppointmentStatus Status { get; set; } = AppointmentStatus.Reserved;
    }
}