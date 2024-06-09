using AutoMapper;
using Core.Entities.OrderAggregate;
using Core.Interfaces;
using Core.Models.UpsertObjects;
using Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Stripe;

namespace Infrastructure.Services
{
    public class PaymentService : IPaymentService
    {
        private readonly IConfiguration _config;
        private readonly BarbershopContext _context;
        private readonly IMapper _mapper;
        public PaymentService(IConfiguration config, BarbershopContext context, IMapper mapper)
        {
            _mapper = mapper;
            _context = context;
            _config = config;
        }

        public async Task<CustomerPaymentDto> CreateOrUpdatePaymentIntent(PaymentUpsertObject upsert)
        {
            StripeConfiguration.ApiKey = _config["StripeSettings:SecretKey"];

            Order order = null;

            if (!string.IsNullOrWhiteSpace(upsert.PaymentIntentId))
            {
                order = await _context.Orders
                    .Include(o => o.OrderItems)
                    .Include(o => o.DeliveryMethod)
                    .Include(o => o.Address)
                    .SingleOrDefaultAsync(o => o.PaymentIntentId == upsert.PaymentIntentId);
            }

            var items = new List<OrderItem>();

            var shippingPrice = 0m;

            DeliveryMethod deliveryMethod = null;

            if (upsert.DeliveryMethodId > 0)
            {
                deliveryMethod = await _context.DeliveryMethods.FirstOrDefaultAsync(m => m.Id == upsert.DeliveryMethodId);
                shippingPrice = deliveryMethod.Price;

                if (order != null) order.DeliveryMethod = deliveryMethod;
            }

            foreach (var item in upsert.Items)
            {
                var product = await _context.Products.SingleOrDefaultAsync(x => x.Id == item.Id);
                var orderItem = new OrderItem()
                {
                    ProductId = product.Id,
                    Price = product.Price,
                    Quantity = item.Quantity,
                };

                items.Add(orderItem);
            }

            if (order != null)
            {
                foreach (var existingItem in order.OrderItems)
                {
                    _context.OrderItems.Remove(existingItem);

                }
                order.OrderItems = items;
                order.DeliveryMethod = deliveryMethod;
                order.Address = _mapper.Map<Core.Entities.Address>(upsert.Address);

                _context.Orders.Update(order);
                await _context.SaveChangesAsync();
            }

            var service = new PaymentIntentService();

            PaymentIntent intent;

            if (string.IsNullOrWhiteSpace(upsert.PaymentIntentId))
            {
                var options = new PaymentIntentCreateOptions
                {
                    Amount = (long)items.Sum(i => i.Quantity * (i.Price * 100)) +
                       (long)shippingPrice * 100,
                    Currency = "usd",
                    PaymentMethodTypes = new List<string> { "card" }
                };

                intent = await service.CreateAsync(options);

                return new CustomerPaymentDto { PaymentIntentId = intent.Id, ClientSecret = intent.ClientSecret };
            }
            else
            {
                var options = new PaymentIntentUpdateOptions
                {
                    Amount = (long)items.Sum(i => i.Quantity * (i.Price * 100)) +
                      (long)shippingPrice * 100
                };

                intent = await service.UpdateAsync(upsert.PaymentIntentId, options);

                return new CustomerPaymentDto { PaymentIntentId = intent.Id, ClientSecret = intent.ClientSecret };
            }
        }

        public async Task<Order> UpdateOrderPaymentFailed(string paymentIntentId)
        {
            var order = await _context.Orders.FirstOrDefaultAsync(o => o.PaymentIntentId == paymentIntentId);

            if (order == null) return null;

            order.Status = OrderStatus.PaymentFailed;
            await _context.SaveChangesAsync();

            return order;
        }

        public async Task<Order> UpdateOrderPaymentSucceeded(string paymentIntentId)
        {
            var order = await _context.Orders.FirstOrDefaultAsync(o => o.PaymentIntentId == paymentIntentId);

            if (order == null) return null;

            order.Status = OrderStatus.PaymentReceived;
            await _context.SaveChangesAsync();

            return order;
        }
    }
}

