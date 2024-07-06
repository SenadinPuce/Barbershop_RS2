using Core.Entities;

namespace Core.Interfaces
{
    public interface IProductRecommendationService
    {
        void TrainModel();
        List<Product> Recommend(int id);
    }
}