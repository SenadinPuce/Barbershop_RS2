namespace Core.Models.SearchObjects
{
    public class AppointmentSearchObject : BaseSearchObject
    {
        public int? BarberId { get; set; }
        public DateTime? Date { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public bool? IsCanceled { get; set; }
        public bool IncludeClient { get; set; } = true;
        public bool IncludeTerm { get; set; } = true;
        public bool IncludeService { get; set; } = true;

    }
}