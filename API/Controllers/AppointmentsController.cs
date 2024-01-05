using API.Dtos;
using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.InsertObjects;
using Core.Models.SearchObjects;
using Core.Models.UpdateObjects;

namespace API.Controllers
{
    public class AppointmentsController : BaseCRUDController<AppointmentDto, Appointment,
        AppointmentSearchObject, AppointmentInsertObject, AppointmentUpdateObject>
    {
        public AppointmentsController(IAppointmentService service, IMapper mapper) : base(service, mapper)
        {
        }
    }
}