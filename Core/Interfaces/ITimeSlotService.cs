using Core.Entities;
using Core.Models.SearchObjects;

namespace Core.Interfaces
{
    public interface ITimeSlotService
    {
        Task<List<TimeSlot>> GetAvailableTimeSlotsAsync(TimeSlotSearchObject search);
    }
}