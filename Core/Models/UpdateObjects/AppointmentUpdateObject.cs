using System.ComponentModel.DataAnnotations;
using Core.Entities;

namespace Core.Models.UpdateObjects
{
    public class AppointmentUpdateObject
    {
        [Required]
        public string Status { get; set; }
    }
}