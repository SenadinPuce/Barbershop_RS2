using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;

namespace API.Controllers
{
    public class ServicesController : BaseCRUDController<Service, Service, ServiceSearchObject, ServiceUpsertObject, ServiceUpsertObject>
    {
        public ServicesController(IBarberService service, IMapper mapper) : base(service, mapper)
        {
        }
    }
}