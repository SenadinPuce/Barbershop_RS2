using API.Dtos;
using API.Errors;
using AutoMapper;
using Core.Entities;
using Core.Entities.OrderAggregate;
using Core.Interfaces;
using Core.Models.InsertObjects;
using Core.Models.SearchObjects;
using Core.Models.UpdateObjects;
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
  

        [HttpPut("update-status/{id}")]
        public async Task<ActionResult<OrderDto>> UpdateOrderStatus(int id, [FromBody] string status)
        {
            var order = await _service.UpdateOrderStatus(id, status);

            if (order == null) return NotFound(new ApiResponse(404));

            return Ok(_mapper.Map<OrderDto>(order));
        }
    }
}