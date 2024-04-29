using AutoMapper;
using Core;
using Core.Entities;
using AppointmentBarberService = Core.Entities.AppointmentService;
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
        private readonly IMessageProducer _messageProducer;
        private new readonly BarbershopContext _context;

        public AppointmentService(BarbershopContext context, IMapper mapper, IMessageProducer messageProducer) : base(context, mapper)
        {
            _context = context;
            _messageProducer = messageProducer;
        }



        public override async Task<Appointment> Update(int id, AppointmentUpdateObject update)
        {
            var appointment = await _context.Appointments
                .FirstOrDefaultAsync(a => a.Id == id);

            _mapper.Map(update, appointment);

            await _context.SaveChangesAsync();

            return appointment;
        }

        public override async Task<Appointment> Insert(AppointmentInsertObject insert)
        {
            var appointment = new Appointment
            {
                StartTime = insert.StartTime,
                BarberId = insert.BarberId,
                ClientId = insert.ClientId,
                AppointmentServices = new List<AppointmentBarberService>()
            };

            foreach (var serviceId in insert.ServiceIds)
            {
                Service service = await _context.Services.FindAsync(serviceId);

                if (service != null)
                {
                    var appointmentService = new AppointmentBarberService
                    {
                        Appointment = appointment,
                        ServiceId = service.Id,
                        Service = service
                    };
                    appointment.AppointmentServices.Add(appointmentService);
                }
            }

            _context.Appointments.Add(appointment);

            await _context.SaveChangesAsync();

            var user = await _context.Users.FindAsync(insert.ClientId);
            var barber = await _context.Users.FindAsync(insert.BarberId);

            var message = new AppointmentMessage
            {
                AppointmentId = appointment.Id,
                ClientEmail = user.Email,
                Service = string.Join(", ", appointment.AppointmentServices.Select(x => x.Service.Name)),
                BarberFullName = $"{barber.FirstName} {barber.LastName}",
                DateTime = appointment.StartTime.ToString("dd MMMM, yyyy HH:mm'h'")
            };
            _messageProducer.SendMessage(message);

            return appointment;
        }

        public override IQueryable<Appointment> AddFilter(IQueryable<Appointment> query, AppointmentSearchObject search)
        {
            if (search.ClientId.HasValue && search.ClientId.Value > 0)
            {
                query = query.Where(a => a.ClientId == search.ClientId);
            }
            if (search.BarberId.HasValue && search.BarberId.Value > 0)
            {
                query = query.Where(a => a.BarberId == search.BarberId);
            }
            if (search.DateFrom.HasValue)
            {
                query = query.Where(a => a.StartTime.Date >= search.DateFrom.Value.Date);
            }
            if (search.DateTo.HasValue)
            {
                query = query.Where(a => a.StartTime.Date <= search.DateTo.Value.Date);
            }
            if (!string.IsNullOrWhiteSpace(search.Status))
            {
                var appointmentStatus = (AppointmentStatus)Enum.Parse(typeof(AppointmentStatus), search.Status, ignoreCase: true);
                query = query.Where(a => a.Status == appointmentStatus);
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

            if (search.IncludeServices)
            {
                query = query.Include(a => a.AppointmentServices).ThenInclude(b => b.Service);
            }

            return query;
        }

    }
}