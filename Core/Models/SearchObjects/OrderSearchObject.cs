namespace Core.Models.SearchObjects
{
    public class OrderSearchObject : BaseSearchObject
    {
        public string Status { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public bool IncludeClient { get; set; }
        public bool IncludeAddress { get; set; }
        public bool IncludeDeliveryMethod { get; set; }
    }
}