namespace Core.Entities
{
    public class Appointment
    {
        public Appointment()
        {
        }

        public Appointment(DateTime startTime, int durationInMinutes, User barber)
        {
            StartTime = startTime;
            DurationInMinutes = durationInMinutes;
            Barber = barber;
        }

        public int Id { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime => StartTime.AddMinutes(DurationInMinutes);
        public int DurationInMinutes { get; set; }
        public AppointmentStatus Status { get; set; } = AppointmentStatus.Free;
        
        public int BarberId { get; set; }
        public User Barber { get; set; }

        public int? ClientId { get; set; }
        public User Client { get; set; }

        public int? ServiceId { get; set; }
        public Service Service { get; set; }
    }
}