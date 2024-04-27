namespace API.Dtos
{
    public class AppointmentDto
    {
        public int Id { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public string Status { get; set; }
        public int BarberId { get; set; }
        public string BarberFullName { get; set; }
        public int ClientId { get; set; }
        public string ClientFullName { get; set; }
        public List<ServiceDto> Services { get; set; }
    }
}