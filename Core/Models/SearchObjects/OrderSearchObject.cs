namespace Core.Models.SearchObjects
{
    public class OrderSearchObject : BaseSearchObject
    {
        public string Status { get; set; }
        public int? ClientId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public bool IncludeClient { get; set; } = true;
        public bool IncludeAddress { get; set; } = true;
        public bool IncludeDeliveryMethod { get; set; } = true;
    }
}