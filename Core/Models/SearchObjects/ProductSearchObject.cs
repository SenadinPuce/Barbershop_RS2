namespace Core.Models.SearchObjects
{
    public class ProductSearchObject : BaseSearchObject
    {
        public int? ProductTypeId { get; set; }
        public int? ProductBrandId { get; set; }
        public string Name { get; set; }
        public bool IncludeProductTypes { get; set; }
        public bool IncludeProductBrands { get; set; }
        public bool IncludeProductPhotos { get; set; }
        public string SortBy { get; set; }
    }
}