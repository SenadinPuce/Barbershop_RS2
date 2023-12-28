using API.Dtos;
using AutoMapper;
using Core.Entities;

namespace API.Helpers
{
    public class AppUserUrlResolver : IValueResolver<AppUser, AppUserDto, string>
    {
        private readonly IConfiguration _config;
        public AppUserUrlResolver(IConfiguration config)
        {
            _config = config;
        }

        public string Resolve(AppUser source, AppUserDto destination, string destMember, ResolutionContext context)
        {
            var photo = source.Photos.FirstOrDefault(x => x.IsMain);

            if (photo != null)
            {
                return _config["ApiUrl"] + photo.PictureUrl;
            }

            return _config["ApiUrl"] + "images/users/placeholder.png";
        }
    }
}