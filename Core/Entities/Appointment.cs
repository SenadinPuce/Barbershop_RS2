namespace Core.Entities
{
    public partial class Appointment
    {
        public int Id { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime => StartTime.AddMinutes(DurationInMinutes);
        public int DurationInMinutes { get; set; }
        public AppointmentStatus Status { get; set; } = AppointmentStatus.Free;
      
        public int BarberId { get; set; }
        public virtual User Barber { get; set; }

        public int? ClientId { get; set; }
        public virtual User Client { get; set; }

        public int? ServiceId { get; set; }
        public virtual Service Service { get; set; }
    }
}