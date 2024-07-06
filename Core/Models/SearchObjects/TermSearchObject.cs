namespace Core.Models.SearchObjects
{
    public class TermSearchObject : BaseSearchObject
    {
        public int? BarberId { get; set; }
        public DateTime? Date { get; set; }
        public bool? IsBooked { get; set; }
        public bool IncludeBarber { get; set; } = true;
    }
}