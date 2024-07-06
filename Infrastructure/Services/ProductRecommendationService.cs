using Core.Entities;
using Core.Interfaces;
using Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;

namespace Infrastructure.Services
{
    public class ProductRecommendationService : IProductRecommendationService
    {
        private static MLContext _mlContext = null;
        private static object _lock = new();
        private static ITransformer _model = null;
        private readonly BarbershopContext _context;

        public ProductRecommendationService(BarbershopContext context)
        {
            _context = context;
        }


        public void TrainModel()
        {
            lock (_lock)
            {
                if (_mlContext == null)
                {
                    _mlContext = new MLContext();

                    var tmpData = _context.Orders.Include(x => x.OrderItems).ToList();

                    var data = new List<ProductEntry>();

                    foreach (var item in tmpData)
                    {
                        if (item.OrderItems.Count > 1)
                        {
                            var distinctItemId = item.OrderItems.Select(y => y.ProductId).ToList();

                            distinctItemId.ForEach(y =>
                            {
                                var relatedItems = item.OrderItems.Where(z => z.ProductId != y);

                                foreach (var z in relatedItems)
                                {
                                    data.Add(new ProductEntry()
                                    {
                                        ProductID = (uint)y,
                                        CoPurchaseProductID = (uint)z.ProductId,
                                    });
                                }
                            });
                        }
                    }

                    var trainData = _mlContext.Data.LoadFromEnumerable(data);

                    var options = new MatrixFactorizationTrainer.Options
                    {
                        MatrixColumnIndexColumnName = nameof(ProductEntry.ProductID),
                        MatrixRowIndexColumnName = nameof(ProductEntry.CoPurchaseProductID),
                        LabelColumnName = "Label",
                        LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                        Alpha = 0.01,
                        Lambda = 0.025,
                        NumberOfIterations = 100,
                        C = 0.00001
                    };

                    var est = _mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    _model = est.Fit(trainData);
                }
            }
        }

        public List<Product> Recommend(int id)
        {
            if (_model == null)
            {
                TrainModel();
            }

            var products = _context.Products.Where(x => x.Id != id);

            var predictionResult = new List<Tuple<Product, float>>();

            foreach (var product in products)
            {
                var predictionEngine = _mlContext.Model.CreatePredictionEngine<ProductEntry, CopurchasePrediction>(_model);
                var prediction = predictionEngine.Predict(new ProductEntry
                {
                    ProductID = (uint)id,
                    CoPurchaseProductID = (uint)product.Id
                });

                predictionResult.Add(new Tuple<Product, float>(product, prediction.Score));
            }

            var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(3).ToList();

            return finalResult;
        }

        public class CopurchasePrediction
        {
            public float Score { get; set; }
        }

        public class ProductEntry
        {
            [KeyType(count: 100)]
            public uint ProductID { get; set; }

            [KeyType(count: 100)]
            public uint CoPurchaseProductID { get; set; }

            public float Label { get; set; }
        }
    }
}