namespace Core.Models.InsertObjects
{
    public class AppointmentInsertObject
    {
        public DateTime StartTime { get; set; }
        public int BarberId { get; set; }
        public int ClientId { get; set; }
        public List<int> ServiceIds { get; set; }
    }
}