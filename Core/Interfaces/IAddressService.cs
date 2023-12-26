using Core.Entities;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;

namespace Core.Interfaces
{
    public interface IAddressService : ICRUDService<Address, BaseSearchObject, AddressUpsertObject, AddressUpsertObject>
    {
    }
}