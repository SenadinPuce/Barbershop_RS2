namespace Core.Entities
{
    public partial class Term
    {
        public int Id { get; set; }
        public int? BarberId { get; set; }
        public AppUser Barber { get; set; }
        public DateTime Date { get; set; }
        public TimeSpan StartTime { get; set; }
        public TimeSpan EndTime { get; set; }
        public bool IsBooked { get; set; } 
    }
}