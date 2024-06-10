using API.Dtos;
using API.Errors;
using AutoMapper;
using Core.Entities;
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
        public async Task<ActionResult<AppUserDto>> Insert(RegisterDto registerDto)
        {
            var user = new AppUser
            {
                FirstName = registerDto.FirstName,
                LastName = registerDto.LastName,
                UserName = registerDto.UserName,
                Email = registerDto.Email,
                PhoneNumber = registerDto.PhoneNumber,
                Photo = registerDto.Photo
            };


            var result = await _userManager.CreateAsync(user, registerDto.Password);

            if (!result.Succeeded) return BadRequest(new ApiResponse(400));

            var roleAddResult = await _userManager.AddToRoleAsync(user, "Barber");

            if (!roleAddResult.Succeeded) return BadRequest(new ApiResponse(400, "Failed to add to role"));

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


        [HttpPut("{id}")]
        public async Task<ActionResult<AppUserDto>> Update(int id, [FromBody] AppUserUpdateRequest update)
        {
            if (update == null) return BadRequest();

            var user = await _userManager.Users
           .Include(u => u.UserRoles).ThenInclude(r => r.Role)
           .FirstOrDefaultAsync(u => u.Id == id);

            if (user == null) return NotFound();

            _mapper.Map(update, user);

            var updateResult = await _userManager.UpdateAsync(user);

            if (!updateResult.Succeeded)
            {
                foreach (var error in updateResult.Errors)
                {
                    ModelState.AddModelError(string.Empty, error.Description);
                }
                return BadRequest(ModelState);
            }

            if (!string.IsNullOrEmpty(update.Password))
            {
                var removePasswordResult = await _userManager.RemovePasswordAsync(user);
                if (!removePasswordResult.Succeeded)
                {
                    foreach (var error in removePasswordResult.Errors)
                    {
                        ModelState.AddModelError(string.Empty, error.Description);
                    }
                    return BadRequest(ModelState);
                }

                var addPasswordResult = await _userManager.AddPasswordAsync(user, update.Password);
                if (!addPasswordResult.Succeeded)
                {
                    foreach (var error in addPasswordResult.Errors)
                    {
                        ModelState.AddModelError(string.Empty, error.Description);
                    }
                    return BadRequest(ModelState);
                }
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
