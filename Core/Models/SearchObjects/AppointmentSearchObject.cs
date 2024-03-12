namespace Core.Models.SearchObjects
{
    public class AppointmentSearchObject : BaseSearchObject
    {
        public int? ClientId { get; set; }
        public int? BarberId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public string Status { get; set; }
        public bool IncludeBarber { get; set; } = true;
        public bool IncludeClient { get; set; } = true;
        public bool IncludeService { get; set; } = true;

    }
}