using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.InsertObjects;
using Core.Models.SearchObjects;
using Core.Models.UpdateObjects;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Data.Repositories
{
    public class AppointmentService : BaseCRUDService<Appointment, AppointmentSearchObject, AppointmentInsertObject, AppointmentUpdateObject>
        , IAppointmentService
    {
        public AppointmentService(BarbershopContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override async Task BeforeInsert(Appointment entity, AppointmentInsertObject insert)
        {
            await base.BeforeInsert(entity, insert);
            entity.EndTime = insert.StartTime.AddMinutes(insert.DurationInMinutes);
        }

        public override IQueryable<Appointment> AddFilter(IQueryable<Appointment> query, AppointmentSearchObject search)
        {
            if (search.BarberId.HasValue)
            {
                query = query.Where(a => a.BarberId == search.BarberId);
            }
            if (search.DateFrom != null)
            {
                query = query.Where(a => a.StartTime.Date >= search.DateFrom);
            }
            if (search.DateTo != null)
            {
                query = query.Where(a => a.EndTime <= search.DateTo);
            }

            return query;
        }

        public override IQueryable<Appointment> AddInclude(IQueryable<Appointment> query, AppointmentSearchObject search)
        {
            if (search.IncludeBarber)
            {
                query = query.Include(a => a.Barber);
            }

            if (search.IncludeClient)
            {
                query = query.Include(a => a.Client);
            }

            if (search.IncludeService)
            {
                query = query.Include(a => a.Service);
            }

            return query;
        }

    }
}