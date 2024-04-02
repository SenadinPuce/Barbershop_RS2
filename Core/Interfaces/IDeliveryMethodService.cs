using Core.Entities.OrderAggregate;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;

namespace Core.Interfaces
{
    public interface IDeliveryMethodService : ICRUDService<DeliveryMethod, BaseSearchObject, DeliveryMethodUpsertObject, DeliveryMethodUpsertObject>
    {

    }
}