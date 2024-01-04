namespace Core.Models.SearchObjects
{
    public class AppointmentSearchObject : BaseSearchObject
    {
        public int? BarberId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }

        public bool IncludeBarber { get; set; } 
        public bool IncludeClient { get; set; }
        public bool IncludeService { get; set; }

    }
}