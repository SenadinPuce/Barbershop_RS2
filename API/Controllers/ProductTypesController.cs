using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;

namespace API.Controllers
{
    public class ProductTypesController : BaseController<ProductType, ProductType, BaseSearchObject>
    {
        public ProductTypesController(IProductTypeService service, IMapper mapper) : base(service, mapper)
        {
        }
    }
}