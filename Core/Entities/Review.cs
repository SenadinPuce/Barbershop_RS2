namespace Core.Entities
{
    public partial class Review
    {
        public int Id { get; set; }
        public int Rating { get; set; }
        public string Comment { get; set; }
        public DateTime CreatedDateTime { get; set; } = DateTime.UtcNow;

        public int ClientId { get; set; }
        public virtual AppUser Client { get; set; }

        public int BarberId { get; set; }
        public virtual AppUser Barber { get; set; }     
    }
}