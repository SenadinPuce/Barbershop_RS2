using API.Dtos;
using AutoMapper;
using Core.Entities;
using Core.Models.SearchObjects;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Controllers
{
    // [Authorize(Roles = "Admin")]
    [ApiController]
    [Route("api/[controller]")]
    public class AdminController : ControllerBase
    {
        private readonly UserManager<AppUser> _userManager;
        private readonly IMapper _mapper;
        public AdminController(UserManager<AppUser> userManager, IMapper mapper)
        {
            _mapper = mapper;
            _userManager = userManager;
        }


        [HttpGet("users-with-roles")]
        public async Task<ActionResult<IReadOnlyList<AppUserDto>>> GetUsersWithRoles([FromQuery] AppUserSearchObject search)
        {
            var query = _userManager.Users;

            if (!string.IsNullOrEmpty(search.RoleName))
            {
                query = query.Where(u => u.UserRoles.Any(ur => ur.Role.Name == search.RoleName));
            }

            if (!string.IsNullOrEmpty(search.Username))
            {
                query = query.Where(u => u.UserName.Contains(search.Username));
            }

            if (search.PageIndex.HasValue == true && search.PageSize.HasValue == true)
            {
                query = query.Skip((search.PageIndex.Value - 1) * search.PageSize.Value).Take(search.PageSize.Value);
            }

            var users = await query.Include(u => u.UserRoles).ThenInclude(r => r.Role).ToListAsync();

            var userDtos = _mapper.Map<List<AppUserDto>>(users);

            return Ok(userDtos);
        }


        [HttpPost("edit-roles/{username}")]
        public async Task<ActionResult> EditRoles(string username, [FromQuery] string roles)
        {
            if (string.IsNullOrEmpty(roles)) return BadRequest("You must select at least one role");

            var selectedRoles = roles.Split(",").ToArray();

            var user = await _userManager.FindByNameAsync(username);

            if (user == null) return NotFound();

            var userRoles = await _userManager.GetRolesAsync(user);

            var result = await _userManager.AddToRolesAsync(user, selectedRoles.Except(userRoles));

            if (!result.Succeeded) return BadRequest("Failed to add to roles");

            result = await _userManager.RemoveFromRolesAsync(user, userRoles.Except(selectedRoles));

            if (!result.Succeeded) return BadRequest("Failed to remove from roles");

            return Ok(await _userManager.GetRolesAsync(user));
        }
    }
}