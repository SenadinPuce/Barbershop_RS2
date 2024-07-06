namespace Core.Entities
{
    public class News
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Content { get; set; }
        public string Photo { get; set; }
        public DateTime CreatedDateTime { get; set; } = DateTime.UtcNow;
        
        public int? AuthorId { get; set; }
        public virtual AppUser Author { get; set; }
    }
}