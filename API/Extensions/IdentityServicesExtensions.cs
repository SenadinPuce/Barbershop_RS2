using Core.Entities;
using Infrastructure.Data;
using Microsoft.AspNetCore.Identity;

namespace API.Extensions
{
    public static class IdentityServicesExtensions
    {
        public static IServiceCollection AddIdentityServices(this IServiceCollection services, IConfiguration config)
        {
            services.AddIdentityCore<AppUser>(opt =>
            {
                // add identity options here
            })
            .AddRoles<AppRole>()
            .AddRoleManager<RoleManager<AppRole>>()
            .AddRoleValidator<RoleValidator<AppRole>>()
            .AddSignInManager<SignInManager<AppUser>>()
            .AddEntityFrameworkStores<BarbershopContext>();

            services.AddAuthentication(); // add jwt auth

            services.AddAuthorization();

            return services;
        }
    }
}