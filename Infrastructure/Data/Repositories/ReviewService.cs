using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Data.Repositories
{
    public class ReviewService : BaseCRUDService<Review, ReviewSearchObject, ReviewUpsertObject, ReviewUpsertObject>, IReviewService
    {
        public ReviewService(BarbershopContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Review> AddInclude(IQueryable<Review> query, ReviewSearchObject search)
        {
            if (search.IncludeClient)
            {
                query = query.Include(x => x.Client);
            }
            return query;
        }

        public override IQueryable<Review> AddFilter(IQueryable<Review> query, ReviewSearchObject search)
        {
            if (search.BarberId != 0)
            {
                query = query.Where(x => x.BarberId == search.BarberId);
            }
            query = query.OrderByDescending(x => x.CreatedDateTime);

            return query;
        }
    }
}