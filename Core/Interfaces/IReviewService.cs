using Core.Entities;
using Core.Models.SearchObjects;

namespace Core.Interfaces
{
    public interface IReviewService : ICRUDService<Review, ReviewSearchObject, ReviewUpsertObject, ReviewUpsertObject>
    {
    }
}