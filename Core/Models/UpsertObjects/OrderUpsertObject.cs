using Core.Models.InsertObjects;

namespace Core.Models.UpsertObjects
{
    public class OrderUpsertObject
    {
        public string PaymentIntentId { get; set; }
        public int DeliveryMethodId { get; set; }
        public AddressUpsertObject Address { get; set; }
        public List<OrderItemInsertObject> Items { get; set; }
    }
}