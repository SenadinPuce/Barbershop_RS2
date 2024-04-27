using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
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
            List<Appointment> bookedAppointments = await _context.Appointments
            .Where(x => x.StartTime.Date.CompareTo(search.Date.Date) == 0 
                && x.BarberId == search.BarberId 
                && x.Status == AppointmentStatus.Reserved)
            .Include(x => x.AppointmentServices).ThenInclude(x => x.Service)
            .ToListAsync();

            DateTime startTime = search.Date.Date.AddHours(9);
            DateTime endTime = search.Date.Date.AddHours(18);

            List<TimeSlot> availableTimeSlots = new List<TimeSlot>();

            while (startTime < endTime)
            {
                if (!IsTimeSlotBooked(bookedAppointments, startTime))
                {
                    availableTimeSlots.Add(new TimeSlot { DateTime = startTime });
                }
                startTime = startTime.AddMinutes(5);
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