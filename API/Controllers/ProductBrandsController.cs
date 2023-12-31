using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;

namespace API.Controllers
{
    public class ProductBrandsController : BaseController<ProductBrand, ProductBrand, BaseSearchObject>
    {
        public ProductBrandsController(IProductBrandService service, IMapper mapper) : base(service, mapper)
        {
        }
    }
}