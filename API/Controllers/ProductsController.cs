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
        private readonly IProductService _service;
        private readonly IMapper _mapper;
        public ProductsController(IProductService service, IMapper mapper)
            : base(service, mapper)
        {
            _mapper = mapper;
            _service = service;
        }


        [HttpPost]
        public override async Task<ActionResult<ProductDto>> Post([FromBody] ProductUpsertObject insert)
        {
            if (insert == null) return BadRequest();

            var created = await _service.Insert(insert);

            if (created != null)
            {
                created = await _service.GetByIdAsync(created.Id);
            }
            return Ok(_mapper.Map<ProductDto>(created));
        }

        [HttpPut("{id}")]
        public override async Task<ActionResult<ProductDto>> Put(int id, [FromBody] ProductUpsertObject insert)
        {
            if (insert == null) return BadRequest();

            var updated = await _service.Update(id, insert);

            if (updated != null)
            {
                updated = await _service.GetByIdAsync(updated.Id);
            }

            return Ok(_mapper.Map<ProductDto>(updated));
        }
    }
}