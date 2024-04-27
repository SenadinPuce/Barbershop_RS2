using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TimeSlotsController : ControllerBase
    {
        private readonly ITimeSlotService _service;
        public TimeSlotsController(ITimeSlotService service)
        {
            _service = service;
        }

        [HttpGet]
        public virtual async Task<ActionResult<IReadOnlyList<TimeSlot>>> Get([FromQuery] TimeSlotSearchObject search)
        {
            var list = await _service.GetAvailableTimeSlotsAsync(search);

            return Ok(list);
        }
    }
}