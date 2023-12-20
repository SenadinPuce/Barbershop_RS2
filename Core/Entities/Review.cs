namespace Core.Entities
{
    public partial class Review
    {
        public int Id { get; set; }
        public int Rating { get; set; }
        public string Comment { get; set; }

        public int UserId { get; set; }
        public virtual User User { get; set; }
        
        public DateTime CreatedDateTime { get; set; } = DateTime.UtcNow;
    }
}