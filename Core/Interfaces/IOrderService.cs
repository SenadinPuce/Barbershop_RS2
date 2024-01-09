using Core.Entities;
using Core.Entities.OrderAggregate;
using Core.Models.InsertObjects;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;

namespace Core.Interfaces
{
    public interface IOrderService : IService<Order, OrderSearchObject>
    {
        Task<Order> CreateOrderAsync(int clientId, OrderUpsertObject request);
        Task<IReadOnlyList<DeliveryMethod>> GetDeliveryMethodsAsync();
        Task<Order> UpdateOrderStatus(int id, string status);
    }
}