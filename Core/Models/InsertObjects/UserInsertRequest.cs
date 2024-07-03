using System.ComponentModel.DataAnnotations;

namespace Core.Models.InsertObjects
{
    public class UserInsertRequest
    {
        [Required]
        [MinLength(3)]
        public string FirstName { get; set; }

        [Required]
        [MinLength(3)]
        public string LastName { get; set; }

        [Required]
        public string UserName { get; set; }

        [Required]
        [EmailAddress]
        public string Email { get; set; }

        public string PhoneNumber { get; set; }

        [Required]
        [MinLength(4,
        ErrorMessage = "Password must have a length greater than or equal to 4")]
        public string Password { get; set; }

        public string Photo { get; set; }

        public string Roles { get; set; }
    }
}