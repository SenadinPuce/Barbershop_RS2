namespace API.Dtos
{
    public class AppointmentDto
    {
        public int Id { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public int DurationInMinutes { get; set; }
        public string Status { get; set; }
        public int BarberId { get; set; }
        public string BarberUsername { get; set; }
        public int? ClientId { get; set; }
        public string ClientUsername { get; set; }
        public int? ServiceId { get; set; }
        public string ServiceName { get; set; }
    }
}