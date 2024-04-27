namespace Core.Models.SearchObjects
{
    public class TimeSlotSearchObject : BaseSearchObject
    {
        public int BarberId { get; set; }
        public DateTime Date { get; set; }
    }
}