namespace Core.Entities
{
    public partial class Appointment
    {
        public int Id { get; set; }
        public int ClientId { get; set; }
        public AppUser Client { get; set; }
        public int? TermId { get; set; }
        public Term Term { get; set; }
        public int ServiceId { get; set; }
        public Service Service { get; set; }
        public DateTime ReservationDate { get; set; } = DateTime.Now;
        public bool IsCanceled { get; set; }      
    }
}