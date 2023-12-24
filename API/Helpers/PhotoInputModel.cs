namespace API.Helpers
{
    public class PhotoInputModel
    {
        
        [MaxFileSize(2 * 1024 * 1024)]
        [AllowedExtensions(new[] { ".jpg", ".png", ".jpeg" })]
        public IFormFile Photo { get; set; }
    }
}