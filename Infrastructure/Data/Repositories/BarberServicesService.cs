using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;

namespace Infrastructure.Data.Repositories
{
    public class BarberServicesService : BaseCRUDService<Service, ServiceSearchObject, ServiceUpsertObject, ServiceUpsertObject>, IBarberServicesService
    {
        public BarberServicesService(BarbershopContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Service> AddFilter(IQueryable<Service> query, ServiceSearchObject search)
        {
            if (!string.IsNullOrWhiteSpace(search.Name))
            {
                query = query.Where(s => s.Name.Contains(search.Name)
                );
            }

            return query;
        }

        public override Task<Service> Delete(int id)
        {
            var appointments = _context.Appointments.Where(a => a.ServiceId == id).ToList();

            foreach (var appointment in appointments)
            {
                appointment.ServiceId = null;
            }

            return base.Delete(id);
        }
    }
}