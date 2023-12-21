using System.ComponentModel.DataAnnotations.Schema;

namespace Core.Entities
{
    [Table("ProductPhotos")]
    public partial class ProductPhoto
    {
        public int Id { get; set; }
        public int PhotoId { get; set; }
        public int ProductId { get; set; }
        public virtual Photo Photo { get; set; }
        public virtual Product Product { get; set; }
    }
}