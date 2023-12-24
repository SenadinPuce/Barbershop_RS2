namespace Core.Entities
{
    public partial class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }

        public int ProductTypeId { get; set; }
        public virtual ProductType ProductType { get; set; }

        public int ProductBrandId { get; set; }
        public virtual ProductBrand ProductBrand { get; set; }

        public virtual List<Photo> Photos { get; set; } = new List<Photo>();

        public void AddPhoto(string pictureUrl, string fileName)
        {
            var photo = new Photo
            {
                FileName = fileName,
                PictureUrl = pictureUrl
            };

            if (Photos.Count == 0) photo.IsMain = true;

            Photos.Add(photo);
        }

        public void RemovePhoto(int id)
        {
            var photo = Photos.Find(x => x.Id == id);
            Photos.Remove(photo);
        }

        public void SetMainPhoto(int id)
        {
            var currentMain = Photos.SingleOrDefault(item => item.IsMain);
            foreach (var item in Photos.Where(item => item.IsMain))
            {
                item.IsMain = false;
            }

            var photo = Photos.Find(x => x.Id == id);
            if (photo != null)
            {
                photo.IsMain = true;
                if (currentMain != null) currentMain.IsMain = false;
            }
        }
    }
}
