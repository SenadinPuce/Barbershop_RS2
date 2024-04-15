using Core.Entities;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;

namespace Core.Interfaces
{
    public interface IProductService : ICRUDService<Product, ProductSearchObject, ProductUpsertObject, ProductUpsertObject>
    {
        List<Product> Recommend(int id);
    }
}