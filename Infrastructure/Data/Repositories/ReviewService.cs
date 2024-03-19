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
                query = query.Include(x => x.User);
            }
            return query;
        }
    }
}