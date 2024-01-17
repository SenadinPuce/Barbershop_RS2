namespace Core.Entities.OrderAggregate
{
    public class ProductItemOrdered
    {
        public ProductItemOrdered()
        {
        }

        public ProductItemOrdered(int productItemId, string productName, string photo)
        {
            ProductItemId = productItemId;
            ProductName = productName;
            Photo = photo;
        }

        public int ProductItemId { get; set; }
        public string ProductName { get; set; }
        public string Photo { get; set; }
    }
}