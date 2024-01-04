using API.Dtos;
using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.InsertObjects;
using Core.Models.SearchObjects;
using Core.Models.UpdateObjects;

namespace API.Controllers
{
    public class AppointmentController : BaseCRUDController<AppointmentDto, Appointment,
        AppointmentSearchObject, AppointmentInsertObject, AppointmentUpdateObject>
    {
        public AppointmentController(IAppointmentService service, IMapper mapper) : base(service, mapper)
        {
        }
    }
}