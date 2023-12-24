using Core.Entities;
using Core.Models.Dto;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;

namespace Core.Interfaces
{
    public interface IProductService : ICRUDService<ProductDto, ProductSearchObject, ProductUpsertObject, ProductUpsertObject>
    {
        Task<ProductDto> AddProductPhoto(int id, Photo photo);
        Task<Photo> DeleteProductPhoto(int id, int photoId);
        Task<ProductDto> SetProductMainPhoto(int id, int photoId);
    }
}