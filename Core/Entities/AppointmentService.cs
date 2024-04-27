using System.ComponentModel.DataAnnotations;

namespace Core.Entities
{
    public class AppointmentService
    {
        [Key] 
        public int AppointmentId { get; set; }

        [Key]
        public int ServiceId { get; set; }
        public virtual Appointment Appointment { get; set; }
        public virtual Service Service { get; set; }
    }
}