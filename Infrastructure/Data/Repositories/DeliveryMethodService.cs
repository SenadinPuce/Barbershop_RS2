using AutoMapper;
using Core.Entities.OrderAggregate;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;

namespace Infrastructure.Data.Repositories
{
    public class DeliveryMethodService : BaseCRUDService<DeliveryMethod, BaseSearchObject,
        DeliveryMethodUpsertObject, DeliveryMethodUpsertObject>, IDeliveryMethodService
    {
        public DeliveryMethodService(BarbershopContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}