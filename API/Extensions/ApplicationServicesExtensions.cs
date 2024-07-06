using API.Errors;
using Core.Interfaces;
using Infrastructure.Data;
using Infrastructure.Data.Repositories;
using Infrastructure.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Extensions
{
    public static class ApplicationServicesExtensions
    {
        public static IServiceCollection AddApplicationServices(this IServiceCollection services, IConfiguration config)
        {
            services.AddDbContext<BarbershopContext>(opt =>
            {
                opt.UseSqlServer(config.GetConnectionString("DefaultConnection"), builder =>
                {
                    builder.EnableRetryOnFailure(5, TimeSpan.FromSeconds(10), null);
                });
            });

            services.AddScoped<IProductService, ProductService>();
            services.AddScoped<IProductBrandService, ProductBrandService>();
            services.AddScoped<IProductTypeService, ProductTypeService>();
            services.AddScoped<IBarberServicesService, BarberServicesService>();
            services.AddScoped<INewsService, NewsService>();
            services.AddScoped<IAppointmentService, AppointmentService>();
            services.AddScoped<IAddressService, AddressService>();
            services.AddScoped<ITokenService, TokenService>();
            services.AddScoped<IOrderService, OrderService>();
            services.AddScoped<IReviewService, ReviewService>();
            services.AddScoped<IDeliveryMethodService, DeliveryMethodService>();
            services.AddScoped<IPaymentService, PaymentService>();
            services.AddScoped<IMessageProducer, MessageProducer>();
            services.AddScoped<ITermService, TermService>();
            services.AddScoped<IProductRecommendationService, ProductRecommendationService>();
            services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());

            services.Configure<ApiBehaviorOptions>(options =>
           {
               options.InvalidModelStateResponseFactory = actionContext =>
               {
                   var errors = actionContext.ModelState
                       .Where(e => e.Value.Errors.Count > 0)
                       .SelectMany(x => x.Value.Errors)
                       .Select(x => x.ErrorMessage).ToArray();

                   var errorResponse = new ApiValidationErrorResponse
                   {
                       Errors = errors
                   };

                   return new BadRequestObjectResult(errorResponse);
               };
           });

            return services;
        }
    }
}