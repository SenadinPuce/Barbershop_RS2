namespace API.Dtos
{
    public class TermDto
    {
        public int Id { get; set; }
        public int BarberId { get; set; }
        public DateTime Date { get; set; }
        public string BarberName { get; set; }
        public TimeSpan StartTime { get; set; }
        public TimeSpan EndTime { get; set; }
        public bool IsBooked { get; set; }
        public bool IsCanceled { get; set; }
    }
}