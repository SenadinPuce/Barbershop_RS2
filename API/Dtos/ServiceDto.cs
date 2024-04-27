namespace API.Dtos
{
    public partial class ServiceDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public decimal Price { get; set; }
        public int DurationInMinutes { get; set; }
    }
}