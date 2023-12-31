using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Data.Repositories
{
    public class ProductService : BaseCRUDService<Product, ProductSearchObject, ProductUpsertObject, ProductUpsertObject>
        , IProductService
    {
        public ProductService(BarbershopContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override async Task<Product> GetByIdAsync(int id)
        {
            var entity = await _context.Products
                .Include(x => x.ProductType)
                .Include(x => x.ProductBrand)
                .Include(x => x.Photos)
                .SingleOrDefaultAsync(x => x.Id == id);

            return entity;
        }

        public override IQueryable<Product> AddFilter(IQueryable<Product> query, ProductSearchObject search)
        {
            if (search.ProductTypeId.HasValue && search.ProductTypeId.Value > 0)
            {
                query = query.Where(x => x.ProductTypeId == search.ProductTypeId);
            }

            if (search.ProductBrandId.HasValue && search.ProductBrandId.Value > 0)
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
    }
}