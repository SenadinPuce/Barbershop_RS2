using API.Errors;
using API.Helpers;
using Core.Interfaces;
using Core.Models.Dto;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{

    public class ProductsController : BaseCRUDController<ProductDto, ProductSearchObject, ProductUpsertObject, ProductUpsertObject>
    {
        private readonly IProductService _service;
        private readonly IPhotoService _photoService;

        public ProductsController(IProductService service, IPhotoService photoService)
            : base(service)
        {
            _service = service;
            _photoService = photoService;
        }

        // out for development
        // [Authorize(Roles = "Admin")] 
        [HttpPut("{id}/photo")]
        public async Task<ActionResult<ProductDto>> AddProductPhoto(int id, [FromForm] PhotoInputModel uploadPhotoFile)
        {
            if (uploadPhotoFile.Photo.Length > 0)
            {
                var photo = await _photoService.SaveToDiskAsync(uploadPhotoFile.Photo);

                if (photo != null)
                {
                    var productDto = await _service.AddProductPhoto(id, photo);
                    return productDto;
                }
            }
            return BadRequest(new ApiResponse(400, "Problem adding product photo"));
        }

        // out for development
        // [Authorize(Roles = "Admin")] 
        [HttpDelete("{id}/photo/{photoId}")]
        public async Task<ActionResult> DeleteProductPhoto(int id, int photoId)
        {
            try
            {
                var photo = await _service.DeleteProductPhoto(id, photoId);

                if (photo != null)
                {
                    _photoService.DeleteFromDisk(photo);
                    return Ok();
                }

                return BadRequest(new ApiResponse(400, "Problem deleting product photo"));
            }
            catch (Exception ex)
            {
                return BadRequest(new ApiResponse(400, ex.Message));
            }
        }

        // out for development
        // [Authorize(Roles = "Admin")] 
        [HttpPatch("{id}/photo/{photoId}")]
        public async Task<ActionResult<ProductDto>> SetMainPhoto(int id, int photoId)
        {
            try
            {
                var productDto = await _service.SetProductMainPhoto(id, photoId);

                if (productDto != null)
                {
                    return Ok(productDto);
                }

                return BadRequest(new ApiResponse(400, "Problem setting product main photo"));
            }
            catch (Exception ex)
            {
                return NotFound(new ApiResponse(404, ex.Message));
            }
        }
    }
}