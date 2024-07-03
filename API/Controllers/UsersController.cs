using API.Dtos;
using API.Errors;
using AutoMapper;
using Core.Entities;
using Core.Models.InsertObjects;
using Core.Models.SearchObjects;
using Core.Models.UpdateObjects;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class UsersController : ControllerBase
    {
        private readonly UserManager<AppUser> _userManager;
        private readonly IMapper _mapper;
        public UsersController(UserManager<AppUser> userManager, IMapper mapper)
        {
            _mapper = mapper;
            _userManager = userManager;
        }

        [HttpGet("users-with-roles")]
        public async Task<ActionResult<IReadOnlyList<AppUserDto>>> GetUsersWithRoles([FromQuery] UserSearchObject search)
        {
            var query = _userManager.Users;

            if (!string.IsNullOrWhiteSpace(search.RoleName))
            {
                query = query.Where(u => u.UserRoles.Any(ur => ur.Role.Name == search.RoleName));
            }

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(u => u.FirstName.Contains(search.FTS) || u.LastName.Contains(search.FTS));
            }

            if (search.PageIndex.HasValue == true && search.PageSize.HasValue == true)
            {
                query = query.Skip((search.PageIndex.Value - 1) * search.PageSize.Value).Take(search.PageSize.Value);
            }

            var users = await query.Include(u => u.UserRoles).ThenInclude(r => r.Role).ToListAsync();

            var userDtos = _mapper.Map<List<AppUserDto>>(users);

            return Ok(userDtos);
        }

        [Authorize(Roles = "Admin")]
        [HttpPost()]
        public async Task<ActionResult<AppUserDto>> Insert(UserInsertRequest insert)
        {
            var user = new AppUser
            {
                FirstName = insert.FirstName,
                LastName = insert.LastName,
                UserName = insert.UserName,
                Email = insert.Email,
                PhoneNumber = insert.PhoneNumber,
                Photo = insert.Photo
            };

            var result = await _userManager.CreateAsync(user, insert.Password);

            if (!result.Succeeded) return BadRequest(new ApiResponse(400));

            if (!string.IsNullOrEmpty(insert.Roles))
            {
                var selectedRoles = insert.Roles.Split(",").ToArray();

                var roleAddResult = await _userManager.AddToRolesAsync(user, selectedRoles);

                if (!roleAddResult.Succeeded) return BadRequest("Failed to add to roles.");
            }
            else
            {
                var roleAddResult = await _userManager.AddToRoleAsync(user, "Client");

                if (!roleAddResult.Succeeded) return BadRequest("Failed to add to role.");
            }

            return Ok(_mapper.Map<AppUserDto>(user));
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<AppUserDto>> GetUserById(int id)
        {
            var user = await _userManager.Users
            .Include(u => u.UserRoles).ThenInclude(r => r.Role)
            .FirstOrDefaultAsync(u => u.Id == id);

            if (user == null)
            {
                return NotFound();
            }

            return Ok(_mapper.Map<AppUserDto>(user));
        }


        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<ActionResult<AppUserDto>> Update(int id, [FromBody] UserUpdateRequest update)
        {
            var user = await _userManager.Users.Include(ur => ur.UserRoles).ThenInclude(r => r.Role)
           .FirstOrDefaultAsync(u => u.Id == id);

            if (user == null) return NotFound();

            _mapper.Map(update, user);

            if (!string.IsNullOrEmpty(update.Roles))
            {
                var selectedRoles = update.Roles.Split(",").ToArray();

                var userRoles = await _userManager.GetRolesAsync(user);

                var result = await _userManager.AddToRolesAsync(user, selectedRoles.Except(userRoles));

                if (!result.Succeeded)
                {
                    return BadRequest(new ApiResponse(400));
                }

                result = await _userManager.RemoveFromRolesAsync(user, userRoles.Except(selectedRoles));

                if (!result.Succeeded)
                {
                    return BadRequest(new ApiResponse(400));
                }
            }

            var updateResult = await _userManager.UpdateAsync(user);

            if (!updateResult.Succeeded)
            {
                return BadRequest(new ApiResponse(400));
            }

            return Ok(_mapper.Map<AppUserDto>(user));
        }


        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var user = await _userManager.FindByIdAsync(id);
            if (user == null)
            {
                return NotFound(new ApiResponse(404, "User not found"));
            }

            var result = await _userManager.DeleteAsync(user);
            if (!result.Succeeded)
            {
                return BadRequest(new ApiResponse(400, "Failed to delete user"));
            }

            return Ok(new ApiResponse(200, "User deleted successfully"));
        }
    }
}
