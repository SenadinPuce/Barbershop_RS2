using API.Dtos;
using AutoMapper;
using Core.Entities.OrderAggregate;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;

namespace API.Controllers
{
    public class DeliveryMethodsController : BaseCRUDController
        <DeliveryMethodDto, DeliveryMethod, BaseSearchObject, DeliveryMethodUpsertObject, DeliveryMethodUpsertObject>
    {

        public DeliveryMethodsController(IDeliveryMethodService service, IMapper mapper)
            : base(service, mapper)
        {

        }
    }

}