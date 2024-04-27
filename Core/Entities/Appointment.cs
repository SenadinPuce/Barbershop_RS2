namespace Core.Entities
{
    public partial class Appointment
    {
        public int Id { get; set; }
        public DateTime StartTime { get; set; }
        public AppointmentStatus Status { get; set; } = AppointmentStatus.Reserved;

        public int BarberId { get; set; }
        public virtual AppUser Barber { get; set; }

        public int ClientId { get; set; }
        public virtual AppUser Client { get; set; }

        public virtual List<AppointmentService> AppointmentServices { get; set; }
    }
}