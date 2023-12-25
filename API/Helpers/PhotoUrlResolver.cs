using API.Dtos;
using AutoMapper;
using Core.Entities;

namespace API.Helpers
{
    public class PhotoUrlResolver : IValueResolver<Photo, PhotoDto, string>
    {
        private readonly IConfiguration _config;
        public PhotoUrlResolver(IConfiguration config)
        {
            _config = config;
        }

        public string Resolve(Photo source, PhotoDto destination, string destMember, ResolutionContext context)
        {
            if (!string.IsNullOrWhiteSpace(source.PictureUrl))
            {
                return _config["ApiUrl"] + source.PictureUrl;
            }
            return null;
        }
    }
}