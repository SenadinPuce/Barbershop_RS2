using System.Security.Claims;
using Core.Entities;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace API.Extensions
{
    public static class UserManagerExtensions
    {
        public static async Task<AppUser> FindUserByClaimsPrincipleWithAddressAsync(
            this UserManager<AppUser> userManager, ClaimsPrincipal user)
        {
            var userName = user.FindFirstValue(ClaimTypes.Name);

            return await userManager.Users.Include(x => x.Address).SingleOrDefaultAsync(x => x.UserName == userName);
        }

        public static async Task<AppUser> FindUserByClaimsPrincipleAsync(
           this UserManager<AppUser> userManager, ClaimsPrincipal user)
        {
            var userName = user.FindFirstValue(ClaimTypes.Name);

            return await userManager.Users.SingleOrDefaultAsync(x => x.UserName == userName);
        }
    }
}