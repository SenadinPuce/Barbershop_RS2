using API.Dtos;
using API.Errors;
using API.Helpers;
using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;
using Infrastructure.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Controllers
{

    public class ProductsController : BaseCRUDController
        <ProductDto, Product, ProductSearchObject, ProductUpsertObject, ProductUpsertObject>
    {
        private readonly IProductService _service;
        private readonly IPhotoService _photoService;
        private readonly BarbershopContext _context;
        private readonly IMapper _mapper;

        public ProductsController(BarbershopContext context, IProductService service,
            IPhotoService photoService, IMapper mapper)
            : base(service, mapper)
        {
            _mapper = mapper;
            _context = context;
            _service = service;
            _photoService = photoService;
        }

        // out for development
        // [Authorize(Roles = "Admin")] 
        [HttpDelete("{id}")]
        public override async Task<ActionResult> Delete(int id)
        {
            var product = await _service.GetByIdAsync(id);

            foreach (var photo in product.Photos)
            {
                if (photo.Id > 16)
                {
                    _photoService.DeleteFromDisk(photo);
                    _context.Photos.Remove(photo);
                }
            }

            if (!await _service.Delete(id))
            {
                return BadRequest(new ApiResponse(400, "Problem deleting product"));
            }

            return Ok();
        }

        // out for development
        // [Authorize(Roles = "Admin")] 
        [HttpPut("{id}/photo")]
        public async Task<ActionResult<ProductDto>> AddProductPhoto(int id, [FromForm] PhotoInputModel uploadPhotoFile)
        {
            var product = await _service.GetByIdAsync(id);

            if (uploadPhotoFile.Photo.Length > 0)
            {
                var photo = await _photoService.SaveToDiskAsync(uploadPhotoFile.Photo);

                if (photo != null)
                {
                    product.AddPhoto(photo.PictureUrl, photo.FileName);

                    _context.Products.Attach(product);
                    _context.Entry(product).State = EntityState.Modified;

                    var result = await _context.SaveChangesAsync();

                    if (result <= 0) return BadRequest(new ApiResponse(400, "Problem adding photo product"));
                }
                else
                {
                    return BadRequest(new ApiResponse(400, "problem saving photo to disk"));
                }
            }

            return _mapper.Map<Product, ProductDto>(product);
        }

        // out for development
        // [Authorize(Roles = "Admin")] 
        [HttpDelete("{id}/photo/{photoId}")]
        public async Task<ActionResult> DeleteProductPhoto(int id, int photoId)
        {
            var product = await _service.GetByIdAsync(id);

            var photo = product.Photos.SingleOrDefault(x => x.Id == photoId);

            if (photo != null)
            {
                if (photo.IsMain)
                    return BadRequest(new ApiResponse(400,
                        "You cannot delete the main photo"));

                _photoService.DeleteFromDisk(photo);
                _context.Remove(photo);
            }
            else
            {
                return BadRequest(new ApiResponse(400, "Photo does not exist"));
            }

            product.RemovePhoto(photoId);

            _context.Products.Attach(product);
            _context.Entry(product).State = EntityState.Modified;

            var result = await _context.SaveChangesAsync();

            if (result <= 0) return BadRequest(new ApiResponse(400, "Problem adding photo product"));

            return Ok();
        }

        // out for development
        // [Authorize(Roles = "Admin")] 
        [HttpPatch("{id}/photo/{photoId}")]
        public async Task<ActionResult<ProductDto>> SetMainPhoto(int id, int photoId)
        {
            var product = await _service.GetByIdAsync(id);

            if (product.Photos.All(x => x.Id != photoId)) return NotFound(new ApiResponse(404));

            product.SetMainPhoto(photoId);

            _context.Products.Attach(product);
            _context.Entry(product).State = EntityState.Modified;

            var result = await _context.SaveChangesAsync();

            if (result <= 0) return BadRequest(new ApiResponse(400, "Problem adding photo product"));

            return _mapper.Map<Product, ProductDto>(product);
        }
    }
}