namespace API.Dtos
{
    public class AppointmentDto
    {
        public int Id { get; set; }
        public int ClientId { get; set; }
        public string ClientName { get; set; }
        public string BarberName { get; set; }
        public int TermId { get; set; }
        public DateTime Date { get; set; }
        public TimeSpan StartTime { get; set; }
        public TimeSpan EndTime { get; set; }
        public int ServiceId { get; set; }
        public string ServiceName { get; set; }
        public decimal ServicePrice { get; set; }
        public DateTime ReservationDate { get; set; }
        public bool IsCanceled { get; set; }
    }
}