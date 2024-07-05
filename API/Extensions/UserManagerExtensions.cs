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
            var userId = user.FindFirstValue(ClaimTypes.NameIdentifier);

            return await userManager.Users.Include(x => x.Address).SingleOrDefaultAsync(x => x.Id == int.Parse(userId));
        }

        public static async Task<AppUser> FindUserByClaimsPrincipleAsync(
           this UserManager<AppUser> userManager, ClaimsPrincipal user)
        {
            var userId = user.FindFirstValue(ClaimTypes.NameIdentifier);

            return await userManager.Users.SingleOrDefaultAsync(x => x.Id == int.Parse(userId));
        }
    }
}