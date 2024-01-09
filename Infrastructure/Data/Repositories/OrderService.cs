using AutoMapper;
using Core.Entities;
using Core.Entities.OrderAggregate;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Data.Repositories
{
    public class OrderService : BaseService<Order, OrderSearchObject>, IOrderService
    {
        private readonly IMapper _mapper;
        public OrderService(BarbershopContext context, IMapper mapper) : base(context)
        {
            _mapper = mapper;
        }

        public async Task<Order> UpdateOrderStatus(int id, string status)
        {
            if (!string.IsNullOrWhiteSpace(status))
            {
                var order = await GetByIdAsync(id);

                if (order != null)
                {
                    var orderStatus = (OrderStatus)Enum.Parse(typeof(OrderStatus), status, ignoreCase: true);

                    order.Status = orderStatus;

                    await _context.SaveChangesAsync();

                    return order;
                }
            }
            return null;
        }

        public async Task<Order> CreateOrderAsync(int clientId, OrderUpsertObject request)
        {
            var items = new List<OrderItem>();

            foreach (var item in request.Items)
            {
                var productItem = await _context.Products.Include(x => x.Photos).SingleOrDefaultAsync(x => x.Id == item.Id);
                var itemOrdered = new ProductItemOrdered(productItem.Id, productItem.Name, productItem.Photos.FirstOrDefault(x => x.IsMain).PictureUrl);
                var orderItem = new OrderItem(itemOrdered, productItem.Price, item.Quantity);
                items.Add(orderItem);
            }

            var deliveryMethod = await _context.DeliveryMethods.FindAsync(request.DeliveryMethodId);

            var subtotal = items.Sum(item => item.Price * item.Quantity);

            var order = _context.Orders.Include(x => x.Address).SingleOrDefault(x => x.PaymentIntentId == request.PaymentIntentId);

            if (order != null)
            {
                _mapper.Map(request.Address, order.Address);
                order.Subtotal = subtotal;
                _context.Orders.Update(order);
            }
            else
            {
                var address = _mapper.Map<Address>(request.Address);
                order = new Order(items, clientId, deliveryMethod, subtotal, request.PaymentIntentId, address);
                _context.Orders.Add(order);
            }

            var result = await _context.SaveChangesAsync();

            if (result <= 0) return null;

            return order;
        }

        public async Task<IReadOnlyList<DeliveryMethod>> GetDeliveryMethodsAsync()
        {
            return await _context.DeliveryMethods.ToListAsync();
        }

        public override IQueryable<Order> AddInclude(IQueryable<Order> query, OrderSearchObject search)
        {
            query = query.Include(x => x.OrderItems);
            if (search.IncludeClient)
            {
                query = query.Include(x => x.Client);
            }
            if (search.IncludeAddress)
            {
                query = query.Include(x => x.Address);
            }
            if (search.IncludeDeliveryMethod)
            {
                query = query.Include(x => x.DeliveryMethod);
            }

            return query;
        }

        public override IQueryable<Order> AddFilter(IQueryable<Order> query, OrderSearchObject search)
        {
            if (!string.IsNullOrWhiteSpace(search.Status))
            {
                OrderStatus orderStatus;

                if (search.Status == "Payment Received")
                {
                    orderStatus = OrderStatus.PaymentReceived;
                }
                else if (search.Status == "Payment Failed")
                {
                    orderStatus = OrderStatus.PaymentFailed;
                }
                else
                {
                    orderStatus = (OrderStatus)Enum.Parse(typeof(OrderStatus), search.Status, ignoreCase: true);
                }
                query = query.Where(o => o.Status == orderStatus);

            }
            if (search.DateFrom != null)
            {
                query = query.Where(o => o.OrderDate.Date >= search.DateFrom.GetValueOrDefault());
            }
            if (search.DateTo != null)
            {
                query = query.Where(o => o.OrderDate.Date <= search.DateTo.GetValueOrDefault());
            }

            return query;
        }

        public override async Task<Order> GetByIdAsync(int id)
        {
            var entity = await _context.Orders
                .Include(o => o.Client)
                .Include(o => o.DeliveryMethod)
                .Include(o => o.Address)
                .Include(o => o.OrderItems)
                .SingleOrDefaultAsync(x => x.Id == id);

            return entity;
        }

    }
}