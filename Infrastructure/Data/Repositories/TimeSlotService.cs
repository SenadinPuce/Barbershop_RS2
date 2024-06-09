using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Data.Repositories
{
    public class TimeSlotService : ITimeSlotService
    {
        private readonly BarbershopContext _context;
        public TimeSlotService(BarbershopContext context)
        {
            _context = context;
        }

        public async Task<List<TimeSlot>> GetAvailableTimeSlotsAsync(TimeSlotSearchObject search)
        {
            if (search.Date.DayOfWeek == DayOfWeek.Saturday || search.Date.DayOfWeek == DayOfWeek.Sunday)
            {
                return new List<TimeSlot>();
            }

            List<Appointment> bookedAppointments = await _context.Appointments
                .Where(x => x.StartTime.Date.CompareTo(search.Date.Date) == 0
                            && x.BarberId == search.BarberId
                            && x.Status == AppointmentStatus.Reserved)
                .Include(x => x.AppointmentServices).ThenInclude(x => x.Service)
                .ToListAsync();

            DateTime now = DateTime.Now;
            DateTime startTime = search.Date.Date > now.Date ? search.Date.Date.AddHours(9) : now;
            DateTime endTime = search.Date.Date.AddHours(18);

            List<TimeSlot> availableTimeSlots = new List<TimeSlot>();

            int intervalMinutes = 5;
            int minutesToAdd = startTime.Minute % intervalMinutes == 0 ? 0 : intervalMinutes - (startTime.Minute % intervalMinutes);
            startTime = startTime.AddMinutes(minutesToAdd);

            while (startTime < endTime)
            {
                if (startTime > now && !IsTimeSlotBooked(bookedAppointments, startTime))
                {
                    availableTimeSlots.Add(new TimeSlot { DateTime = startTime });
                }
                startTime = startTime.AddMinutes(intervalMinutes);
            }

            return availableTimeSlots;
        }

        private bool IsTimeSlotBooked(List<Appointment> appointments, DateTime timeSlot)
        {
            foreach (var appointment in appointments)
            {
                DateTime appointmentStartTime = appointment.StartTime;
                DateTime appointmentEndTime = appointmentStartTime;

                foreach (var appointmentService in appointment.AppointmentServices)
                {
                    appointmentEndTime = appointmentEndTime.AddMinutes(appointmentService.Service.DurationInMinutes);
                }

                if (timeSlot >= appointmentStartTime && timeSlot < appointmentEndTime)
                {
                    return true;
                }
            }

            return false;
        }


    }
}