using API.Dtos;
using API.Errors;
using API.Extensions;
using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.UpsertObjects;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AccountController : ControllerBase
    {
        private readonly UserManager<AppUser> _userManager;
        private readonly SignInManager<AppUser> _signInManager;
        private readonly ITokenService _tokenService;
        private readonly IMapper _mapper;
        private readonly IAddressService _addressService;
        public AccountController(UserManager<AppUser> userManager, SignInManager<AppUser> signInManager,
            ITokenService tokenService, IMapper mapper, IAddressService addressService)
        {
            _addressService = addressService;
            _mapper = mapper;
            _tokenService = tokenService;
            _signInManager = signInManager;
            _userManager = userManager;
        }

        [HttpPost("login")]
        public async Task<ActionResult<AuthorizationDto>> Login(LoginDto loginDto)
        {
            var user = await _userManager.FindByNameAsync(loginDto.Username);

            if (user == null) return Unauthorized("Invalid username or password.");

            var result = await _signInManager.CheckPasswordSignInAsync(user, loginDto.Password, false);

            if (!result.Succeeded) return Unauthorized("Invalid username or password.");

            return new AuthorizationDto
            {
                Id = user.Id,
                Username = user.UserName,
                Email = user.Email,
                Token = await _tokenService.CreateToken(user)
            };
        }

        [HttpPost("login/admin")]
        public async Task<ActionResult<AuthorizationDto>> LoginAdmin(LoginDto loginDto)
        {
            var user = await _userManager.FindByNameAsync(loginDto.Username);

            if (user == null)
            {
                return Unauthorized("Invalid username or password.");
            }

            var result = await _signInManager.CheckPasswordSignInAsync(user, loginDto.Password, false);

            if (!result.Succeeded)
            {
                return Unauthorized("Invalid username or password.");
            }

            var roles = await _userManager.GetRolesAsync(user);

            if (!roles.Contains("Admin") && !roles.Contains("Barber"))
            {
                return Forbid();
            }

            return new AuthorizationDto
            {
                Id = user.Id,
                Username = user.UserName,
                Email = user.Email,
                Role = roles[0],
                Token = await _tokenService.CreateToken(user)
            };
        }



        [HttpPost("register")]
        public async Task<ActionResult<AuthorizationDto>> Register(RegisterDto registerDto)
        {
            if (CheckUserNameExistsAsync(registerDto.UserName).Result.Value)
            {
                return new BadRequestObjectResult(new ApiValidationErrorResponse { Errors = new[] { "Username is in use" } });
            }

            var user = new AppUser
            {
                FirstName = registerDto.FirstName,
                LastName = registerDto.LastName,
                UserName = registerDto.UserName,
                Email = registerDto.Email
            };

            var result = await _userManager.CreateAsync(user, registerDto.Password);

            if (!result.Succeeded) return BadRequest(new ApiResponse(400));

            var roleAddResult = await _userManager.AddToRoleAsync(user, "Client");

            if (!roleAddResult.Succeeded) return BadRequest(new ApiResponse(400, "Failed to add to role"));

            return new AuthorizationDto
            {
                Id = user.Id,
                Username = user.UserName,
                Email = user.Email,
                Token = await _tokenService.CreateToken(user)
            };
        }

        [HttpGet("userNameExists")]
        public async Task<ActionResult<bool>> CheckUserNameExistsAsync([FromQuery] string userName)
        {
            return await _userManager.FindByNameAsync(userName) != null;
        }

        [Authorize]
        [HttpGet("address")]
        public async Task<ActionResult<AddressDto>> GetUserAddress()
        {
            var user = await _userManager.FindUserByClaimsPrincipleWithAddressAsync(User);

            if (user.Address == null) return new AddressDto();

            return _mapper.Map<AddressDto>(user.Address);
        }

        [Authorize]
        [HttpPut("address")]
        public async Task<ActionResult<AddressDto>> UpdateUserAddress(AddressUpsertObject addressUpsert)
        {
            var user = await _userManager.FindUserByClaimsPrincipleWithAddressAsync(User);

            if (user.Address == null)
            {
                user.Address = await _addressService.Insert(addressUpsert);
            }
            else
            {
                _mapper.Map(addressUpsert, user.Address);
            }

            var result = await _userManager.UpdateAsync(user);

            if (result.Succeeded) return Ok(_mapper.Map<AddressDto>(user.Address));

            return BadRequest(new ApiResponse(400, "Problem updating the user"));
        }
    }
}