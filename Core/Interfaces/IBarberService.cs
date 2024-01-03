using Core.Entities;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;

namespace Core.Interfaces
{
    public interface IBarberService : ICRUDService<Service, ServiceSearchObject, ServiceUpsertObject, ServiceUpsertObject>
    {
    }
}