using Microsoft.AspNetCore.Identity;

namespace Core.Entities
{
    public partial class AppRole : IdentityRole<int>
    {
        public virtual ICollection<AppUserRole> UserRoles { get; set; }
    }
}