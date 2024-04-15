using System.Security.Cryptography.X509Certificates;
using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using Microsoft.VisualBasic;

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
                case "name":
                    query = query.OrderBy(x => x.Name);
                    break;
                default:
                    break;
            }

            return query;
        }

        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;

        public List<Product> Recommend(int id)
        {
            lock (isLocked)
            {
                if (mlContext == null)
                {
                    mlContext = new MLContext();

                    var tmpData = _context.Orders.Include(x => x.OrderItems).ToList();

                    var data = new List<ProductEntry>();

                    foreach (var item in tmpData)
                    {
                        if (item.OrderItems.Count > 1)
                        {
                            var distinctItemId = item.OrderItems.Select(y => y.ItemOrdered.ProductItemId).ToList();

                            distinctItemId.ForEach(y =>
                            {
                                var relatedItems = item.OrderItems.Where(z => z.ItemOrdered.ProductItemId != y);

                                foreach (var z in relatedItems)
                                {
                                    data.Add(new ProductEntry()
                                    {
                                        ProductID = (uint)y,
                                        CoPurchaseProductID = (uint)z.ItemOrdered.ProductItemId,
                                    });
                                }
                            });
                        }
                    }

                    var traindata = mlContext.Data.LoadFromEnumerable(data);

                    MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                    options.MatrixColumnIndexColumnName = nameof(ProductEntry.ProductID);
                    options.MatrixRowIndexColumnName = nameof(ProductEntry.CoPurchaseProductID);
                    options.LabelColumnName = "Label";
                    options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                    options.Alpha = 0.01;
                    options.Lambda = 0.025;
                    // For better results use the following parameters
                    options.NumberOfIterations = 100;
                    options.C = 0.00001;

                    var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    model = est.Fit(traindata);
                }
            }

            var products = _context.Products.Where(x => x.Id != id);

            var predictionResult = new List<Tuple<Product, float>>();

            foreach (var product in products)
            {
                var predictionengine = mlContext.Model.CreatePredictionEngine<ProductEntry, Copurchase_prediction>(model);
                var prediction = predictionengine.Predict(
                                         new ProductEntry()
                                         {
                                             ProductID = (uint)id,
                                             CoPurchaseProductID = (uint)product.Id
                                         });

                predictionResult.Add(new Tuple<Product, float>(product, prediction.Score));
            }

            var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(3).ToList();

            return finalResult;
        }

        public class Copurchase_prediction
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