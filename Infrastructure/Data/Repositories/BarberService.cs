using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;

namespace Infrastructure.Data.Repositories
{
    public class BarberService : BaseCRUDService<Service, ServiceSearchObject, ServiceUpsertObject, ServiceUpsertObject>, IBarberService
    {
        public BarberService(BarbershopContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Service> AddFilter(IQueryable<Service> query, ServiceSearchObject search)
        {
            if (!string.IsNullOrWhiteSpace(search.Name))
            {
                query = query.Where(s => s.Name.Contains(search.Name));
            }

            return query;
        }
    }
}