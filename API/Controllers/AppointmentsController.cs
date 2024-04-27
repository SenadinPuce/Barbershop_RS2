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
        public AppointmentsController(IAppointmentService service, IMapper mapper) : base(service, mapper)
        {

        }
    }
}