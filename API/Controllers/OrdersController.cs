using API.Dtos;
using API.Errors;
using API.Extensions;
using AutoMapper;
using Core.Entities;
using Core.Entities.OrderAggregate;
using Core.Interfaces;
using Core.Models.InsertObjects;
using Core.Models.SearchObjects;
using Core.Models.UpdateObjects;
using Core.Models.UpsertObjects;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    public class OrdersController : BaseCRUDController<OrderDto, Order, OrderSearchObject, OrderInsertObject, OrderUpdateObject>
    {
        private readonly IOrderService _service;
        // private readonly UserManager<AppUser> _userManager;
        private readonly IMapper _mapper;
        public OrdersController(UserManager<AppUser> userManager, IOrderService service, IMapper mapper) : base(service, mapper)
        {
            _mapper = mapper;
            // _userManager = userManager;
            _service = service;
        }

        // [HttpPost]
        // public async Task<ActionResult<Order>> CreateOrder(OrderUpsertObject request)
        // {
        //     var user = await _userManager.FindUserByClaimsPrincipleAsync(User);

        //     var order = await _service.CreateOrderAsync(user.Id, request);

        //     if (order == null) return BadRequest(new ApiResponse(400, "Problem creating order"));

        //     return Ok(order);
        // }

        [HttpPut("update-status/{id}")]
        public async Task<ActionResult<OrderDto>> UpdateOrderStatus(int id, [FromBody] string status)
        {
            var order = await _service.UpdateOrderStatus(id, status);

            if (order == null) return NotFound(new ApiResponse(404));

            return Ok(_mapper.Map<OrderDto>(order));
        }
    }
}