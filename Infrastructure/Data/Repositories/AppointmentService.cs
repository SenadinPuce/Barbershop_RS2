using AutoMapper;
using Core;
using Core.Entities;
using Core.Interfaces;
using Core.Models.InsertObjects;
using Core.Models.SearchObjects;
using Core.Models.UpdateObjects;
using Microsoft.EntityFrameworkCore;
using CloudinaryDotNet.Actions;

namespace Infrastructure.Data.Repositories
{
    public class AppointmentService : BaseCRUDService<Appointment, AppointmentSearchObject, AppointmentInsertObject, AppointmentUpdateObject>
        , IAppointmentService
    {
        private readonly IMessageProducer _messageProducer;
        private new readonly BarbershopContext _context;

        public AppointmentService(BarbershopContext context, IMapper mapper, IMessageProducer messageProducer) : base(context, mapper)
        {
            _context = context;
            _messageProducer = messageProducer;
        }

        public override async Task<Appointment> Insert(AppointmentInsertObject insert)
        {
            var appointment = new Appointment
            {
                TermId = insert.TermId,
                ClientId = insert.ClientId,
                ServiceId = insert.ServiceId
            };

            _context.Appointments.Add(appointment);

            var term = await _context.Terms.Include(t => t.Barber).FirstOrDefaultAsync(t => t.Id == insert.TermId);
            var user = await _context.Users.FindAsync(insert.ClientId);
            var service = await _context.Services.FindAsync(insert.ServiceId);

            term.IsBooked = true;

            await _context.SaveChangesAsync();


            var message = new AppointmentMessage
            {
                AppointmentId = appointment.Id,
                ClientEmail = user.Email,
                Service = service.Name,
                BarberFullName = $"{term.Barber.FirstName} {term.Barber.LastName}",
                Date = term.Date.ToString("dd MMMM yyyy"),
                Time = term.StartTime.ToString("HH:mm")
            };
            _messageProducer.SendMessage(message);

            return appointment;
        }

        public override IQueryable<Appointment> AddInclude(IQueryable<Appointment> query, AppointmentSearchObject search)
        {
            if (search.IncludeClient)
                query = query.Include(a => a.Client);
            if (search.IncludeService)
                query = query.Include(a => a.Service);
            if (search.IncludeTerm)
                query = query.Include(a => a.Term);
            return query;
        }

        public override IQueryable<Appointment> AddFilter(IQueryable<Appointment> query, AppointmentSearchObject search)
        {
            if (search.IsCanceled.HasValue)
            {
                query = query.Where(a => a.IsCanceled == search.IsCanceled.Value);
            }
            if (search.BarberId.HasValue)
            {
                query = query.Where(a => a.Term.BarberId == search.BarberId);
            }
            if (search.Date.HasValue)
            {
                query = query.Where(a => a.ReservationDate.Date == search.Date.Value.Date);
            }
            if (search.DateFrom.HasValue)
            {
                query = query.Where(a => a.ReservationDate.Date >= search.DateFrom.Value.Date);
            }
            if (search.DateTo.HasValue)
            {
                query = query.Where(a => a.ReservationDate.Date <= search.DateTo.Value.Date);
            }

            return query;
        }
    }
}