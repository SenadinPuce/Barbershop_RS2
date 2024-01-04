using Core.Entities;

namespace Core.Models.InsertObjects
{
    public class AppointmentInsertObject
    {
        public DateTime StartTime { get; set; }
        public int DurationInMinutes { get; set; }
        public int BarberId { get; set; }
    }
}