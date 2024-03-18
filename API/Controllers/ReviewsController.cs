using API.Dtos;
using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;

namespace API.Controllers
{
    public class ReviewsController : BaseCRUDController<ReviewDto, Review, ReviewSearchObject, ReviewUpsertObject, ReviewUpsertObject>
    {
        public ReviewsController(IReviewService service, IMapper mapper) : base(service, mapper)
        {
        }
    }
}