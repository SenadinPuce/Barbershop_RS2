using API.Dtos;
using API.Errors;
using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.InsertObjects;
using Core.Models.SearchObjects;
using Core.Models.UpdateObjects;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    public class AppointmentsController : BaseCRUDController<AppointmentDto, Appointment,
        AppointmentSearchObject, AppointmentInsertObject, AppointmentUpdateObject>
    {
        private readonly IAppointmentService _service;
        private readonly IMapper _mapper;
        public AppointmentsController(IAppointmentService service, IMapper mapper) : base(service, mapper)
        {
            _mapper = mapper;
            _service = service;
        }

        [HttpPut("update-status/{id}")]
        public async Task<ActionResult<AppointmentDto>> UpdateAppointmentStatus(int id,[FromBody] string status)
        {
            var appointment = await _service.UpdateAppointmentStatus(id, status);

            if (appointment == null) return NotFound(new ApiResponse(404));

            return Ok(_mapper.Map<AppointmentDto>(appointment));
        }
    }
}