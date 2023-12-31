using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;

namespace Infrastructure.Data.Repositories
{
    public class ProductBrandService : BaseService<ProductBrand, BaseSearchObject>, IProductBrandService
    {
        public ProductBrandService(BarbershopContext context) : base(context)
        {
        }
    }
}