using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;

namespace Infrastructure.Data.Repositories
{
    public class ReviewService : BaseCRUDService<Review, ReviewSearchObject, ReviewUpsertObject, ReviewUpsertObject>, IReviewService
    {
        public ReviewService(BarbershopContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}