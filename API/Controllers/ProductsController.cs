using API.Dtos;
using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    public class ProductsController : BaseCRUDController
        <ProductDto, Product, ProductSearchObject, ProductUpsertObject, ProductUpsertObject>
    {
        private readonly IMapper _mapper;
        private readonly IProductService _service;

        public ProductsController(IProductService service, IMapper mapper)
            : base(service, mapper)
        {
            _service = service;
            _mapper = mapper;

        }

        [HttpGet("{id}/recommend")]
        public List<ProductDto> Recommend(int id)
        {
            return _mapper.Map<List<ProductDto>>(_service.Recommend(id));
        }
    }

}