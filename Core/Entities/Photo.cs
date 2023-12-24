namespace Core.Entities
{
    public partial class Photo
    {
        public int Id { get; set; }
        public string PictureUrl { get; set; }
        public string FileName { get; set; }
        public bool IsMain { get; set; }

        public virtual ICollection<AppUser> AppUsers { get; set; }
        public virtual ICollection<Product> Products { get; set; }
    }
}