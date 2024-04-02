using System.ComponentModel.DataAnnotations;
using Core.Models.UpsertObjects;

namespace Core.Models.InsertObjects
{
    public class OrderInsertObject
    {
        [Required]
        public string PaymentIntentId { get; set; }
        
        [Required]
        public int DeliveryMethodId { get; set; }

        [Required]
        public int ClientId { get; set; }

        [Required]
        public AddressUpsertObject Address { get; set; }

        [Required]
        public List<OrderItemInsertObject> Items { get; set; }
    }
}