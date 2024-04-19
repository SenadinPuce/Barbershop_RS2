namespace Core.Models.SearchObjects
{
    public class NewsSearchObject : BaseSearchObject
    {
        public string Title { get; set; }
        public bool IncludeAuthor { get; set; }
    }
}