using System.ComponentModel.DataAnnotations;

namespace API.Dtos
{
    public class UserUpdateDto
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
        public string Password { get; set; }
    }
}