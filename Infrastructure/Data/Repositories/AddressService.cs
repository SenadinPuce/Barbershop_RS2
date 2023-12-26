using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;

namespace Infrastructure.Data.Repositories
{
    public class AddressService : BaseCRUDService<Address, BaseSearchObject, AddressUpsertObject, AddressUpsertObject>,
        IAddressService
    {
        public AddressService(BarbershopContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}