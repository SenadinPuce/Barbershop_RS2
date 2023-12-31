using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;

namespace Infrastructure.Data.Repositories
{
    public class ProductTypeService : BaseService<ProductType, BaseSearchObject>, IProductTypeService
    {
        public ProductTypeService(BarbershopContext context) : base(context)
        {
        }
    }
}