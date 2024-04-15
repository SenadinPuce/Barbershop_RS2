using System.ComponentModel.DataAnnotations;
using Core.Models.InsertObjects;

namespace Core.Models.UpsertObjects
{
    public class PaymentUpsertObject
    {
        public string PaymentIntentId { get; set; }

        [Required]
        public int DeliveryMethodId { get; set; }

        [Required]
        public AddressUpsertObject Address { get; set; }

        [Required]
        public List<OrderItemInsertObject> Items { get; set; }
    }
}