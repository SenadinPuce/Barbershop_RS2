using Core.Entities;

namespace Infrastructure.Data
{
    public class AppointmentModel
    {
        public DateTime StartTime { get; set; }
        public int BarberId { get; set; }
        public int ClientId { get; set; }

        public virtual List<int> ServiceIds { get; set; }
    }
}