using AutoMapper;
using Core;
using Core.Entities;
using Core.Interfaces;
using Core.Models.InsertObjects;
using Core.Models.SearchObjects;
using Core.Models.UpdateObjects;
using EasyNetQ;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace Infrastructure.Data.Repositories
{
    public class AppointmentService : BaseCRUDService<Appointment, AppointmentSearchObject, AppointmentInsertObject, AppointmentUpdateObject>
        , IAppointmentService
    {
        private readonly IMessageProducer _messageProducer;

        public AppointmentService(BarbershopContext context, IMapper mapper, IMessageProducer messageProducer) : base(context, mapper)
        {
            _messageProducer = messageProducer;
        }

        public async Task<Appointment> UpdateAppointmentStatus(int id, string status)
        {
            if (!string.IsNullOrWhiteSpace(status))
            {
                var appointment = await _context.Appointments
                    .Include(a => a.Client)
                    .Include(a => a.Barber)
                    .Include(a => a.Service)
                    .FirstOrDefaultAsync(a => a.Id == id);

                if (appointment != null)
                {
                    var appointmentStatus = (AppointmentStatus)Enum.Parse(typeof(AppointmentStatus), status, ignoreCase: true);

                    appointment.Status = appointmentStatus;

                    if (appointment.Status == AppointmentStatus.Reserved)
                    {
                        var message = new AppointmentMessage
                        {
                            AppointmentId = appointment.Id,
                            ClientEmail = appointment.Client.Email,
                            Service = appointment.Service.Name,
                            BarberFullName = $"{appointment.Barber.FirstName} {appointment.Barber.LastName}",
                            DateTime = appointment.StartTime.ToString("dd MMMM, yyyy HH:mm'h'")
                        };
                        _messageProducer.SendMessage(message);
                    }

                    await _context.SaveChangesAsync();

                    return appointment;
                }
            }
            return null;
        }

        public override async Task BeforeInsert(Appointment entity, AppointmentInsertObject insert)
        {
            await base.BeforeInsert(entity, insert);
            entity.EndTime = insert.StartTime.AddMinutes(insert.DurationInMinutes);
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
            if (search.DateFrom != null)
            {
                query = query.Where(a => a.StartTime.Date >= search.DateFrom.GetValueOrDefault().Date);
            }
            if (search.DateTo != null)
            {
                query = query.Where(a => a.EndTime.Date <= search.DateTo.GetValueOrDefault().Date);
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

            if (search.IncludeService)
            {
                query = query.Include(a => a.Service);
            }

            return query;
        }

    }
}