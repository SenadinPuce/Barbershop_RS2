using Core.Entities.OrderAggregate;
using Core.Models.UpsertObjects;

namespace Core.Interfaces
{
    public interface IPaymentService
    {
        Task<CustomerPaymentDto> CreateOrUpdatePaymentIntent(PaymentUpsertObject insert);
        Task<Order> UpdateOrderPaymentSucceeded(string paymentIntentId);
        Task<Order> UpdateOrderPaymentFailed(string paymentIntentId);
    }

    public class CustomerPaymentDto
    {
        public string ClientSecret { get; set; }
        public string PaymentIntentId { get; set; }
    }
}