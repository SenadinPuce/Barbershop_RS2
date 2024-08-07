using System.ComponentModel.DataAnnotations;

namespace Core.Models.UpdateObjects
{
    public class UserUpdateRequest
    {
        [Required]
        [MinLength(3)]
        public string FirstName { get; set; }

        [Required]
        [MinLength(3)]
        public string LastName { get; set; }

        [Required]
        [MinLength(3)]
        public string UserName { get; set; }

        [Required]
        [EmailAddress]
        public string Email { get; set; }

        public string PhoneNumber { get; set; }
        public string Photo { get; set; }
        public string Roles { get; set; }
    }
}