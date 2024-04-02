using Core.Entities.OrderAggregate;
using Core.Models.InsertObjects;
using Core.Models.SearchObjects;
using Core.Models.UpdateObjects;

namespace Core.Interfaces
{
    public interface IOrderService : ICRUDService<Order, OrderSearchObject, OrderInsertObject, OrderUpdateObject>
    {
        // Task<Order> CreateOrderAsync(int clientId, OrderUpsertObject request);
        Task<IReadOnlyList<DeliveryMethod>> GetDeliveryMethodsAsync();
        Task<Order> UpdateOrderStatus(int id, string status);
    }
}