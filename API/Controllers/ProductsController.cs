using API.Dtos;
using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;

namespace API.Controllers
{
    public class ProductsController : BaseCRUDController
        <ProductDto, Product, ProductSearchObject, ProductUpsertObject, ProductUpsertObject>
    {

        public ProductsController(IProductService service, IMapper mapper)
            : base(service, mapper)
        {

        }
    }

}