using Core.Entities;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;

namespace Core.Interfaces
{
    public interface IBarberServicesService : ICRUDService<Service, ServiceSearchObject, ServiceUpsertObject, ServiceUpsertObject>
    {
    }
}