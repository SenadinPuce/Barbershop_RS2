using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.Dto;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Data.Repositories
{
    public class ProductService : BaseCRUDService<ProductDto, Product, ProductSearchObject, ProductUpsertObject, ProductUpsertObject>
        , IProductService
    {
        public ProductService(BarbershopContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override async Task<ProductDto> GetByIdAsync(int id)
        {
            var entity = await _context.Products
                .Include(x => x.ProductType)
                .Include(x => x.ProductBrand)
                .Include(x => x.Photos)
                .SingleOrDefaultAsync(x => x.Id == id);

            return _mapper.Map<ProductDto>(entity);
        }

        public override IQueryable<Product> AddFilter(IQueryable<Product> query, ProductSearchObject search)
        {
            if (search.ProductTypeId.HasValue)
            {
                query = query.Where(x => x.ProductTypeId == search.ProductTypeId);
            }

            if (search.ProductBrandId.HasValue)
            {
                query = query.Where(x => x.ProductBrandId == search.ProductBrandId);
            }

            if (!string.IsNullOrWhiteSpace(search.Name))
            {
                query = query.Where(x => x.Name.Contains(search.Name));
            }

            return query;
        }

        public override IQueryable<Product> AddInclude(IQueryable<Product> query, ProductSearchObject search)
        {
            if (search.IncludeProductBrands)
            {
                query = query.Include(x => x.ProductBrand);
            }

            if (search.IncludeProductTypes)
            {
                query = query.Include(x => x.ProductType);
            }

            if (search.IncludeProductPhotos)
            {
                query = query.Include(x => x.Photos);
            }

            return query;
        }

        public override IQueryable<Product> AddSorting(IQueryable<Product> query, ProductSearchObject search)
        {
            switch (search.SortBy)
            {
                case "priceAsc":
                    query = query.OrderBy(x => x.Price);
                    break;
                case "priceDesc":
                    query = query.OrderByDescending(x => x.Price);
                    break;
                default:
                    query = query.OrderBy(x => x.Name);
                    break;
            }

            return query;
        }

        public async Task<ProductDto> AddProductPhoto(int id, Photo photo)
        {
            var product = await _context.Products
                .Include(x => x.ProductType)
                .Include(x => x.ProductBrand)
                .Include(x => x.Photos)
                .SingleOrDefaultAsync(x => x.Id == id);

            product.AddPhoto(photo.PictureUrl, photo.FileName);

            _context.Products.Attach(product);
            _context.Entry(product).State = EntityState.Modified;

            await _context.SaveChangesAsync();

            return _mapper.Map<ProductDto>(product);
        }

        public async Task<Photo> DeleteProductPhoto(int id, int photoId)
        {
            var product = await _context.Products
             .Include(x => x.Photos)
             .SingleOrDefaultAsync(x => x.Id == id);

            var photo = product.Photos.SingleOrDefault(x => x.Id == photoId);

            if (photo != null)
            {
                if (photo.IsMain)
                    throw new Exception("You cannot delete the main photo");
            }
            else
            {
                throw new Exception("Photo does not exists");
            }

            product.RemovePhoto(photoId);

            _context.Products.Attach(product);
            _context.Entry(product).State = EntityState.Modified;

            await _context.SaveChangesAsync();

            return photo;
        }

        public async Task<ProductDto> SetProductMainPhoto(int id, int photoId)
        {
            var product = await _context.Products
                .Include(x => x.ProductType)
                .Include(x => x.ProductBrand)
                .Include(x => x.Photos)
                .SingleOrDefaultAsync(x => x.Id == id);

            if (product.Photos.All(x => x.Id != photoId)) throw new Exception("Photo doesn't exists for searched product");

            product.SetMainPhoto(photoId);

            _context.Products.Attach(product);
            _context.Entry(product).State = EntityState.Modified;

            await _context.SaveChangesAsync();

            return _mapper.Map<ProductDto>(product);
        }
    }
}