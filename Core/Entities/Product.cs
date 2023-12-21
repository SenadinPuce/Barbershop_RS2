namespace Core.Entities
{
    public partial class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }

        public int ProductTypeId { get; set; }
        public virtual ProductType ProductType { get; set; }

        public int ProductBrandId { get; set; }
        public virtual ProductBrand ProductBrand { get; set; }
        
        public virtual ICollection<ProductPhoto> Photos { get; set; }
    }
}
