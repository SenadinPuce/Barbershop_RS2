using Microsoft.AspNetCore.Identity;

namespace Core.Entities
{
    public partial class AppUser : IdentityUser<int>
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }

        public int? PhotoId { get; set; }
        public virtual Photo Photo { get; set; }

        public int? AddressId { get; set; }
        public virtual Address Address { get; set; }

        public virtual ICollection<AppUserRole> UserRoles { get; set; }
    }
}