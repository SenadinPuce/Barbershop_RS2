using Core.Entities;
using Core.Models.InsertObjects;
using Core.Models.SearchObjects;
using Core.Models.UpdateObjects;

namespace Core.Interfaces
{
    public interface IAppointmentService : ICRUDService<Appointment, AppointmentSearchObject, AppointmentInsertObject, AppointmentUpdateObject>
    {
        Task<Appointment> UpdateAppointmentStatus(int id, string status);
    }
}