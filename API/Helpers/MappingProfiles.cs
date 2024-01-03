using API.Dtos;
using AutoMapper;
using Core.Entities;
using Core.Models.UpsertObjects;

namespace API.Helpers
{
    public class MappingProfiles : Profile
    {
        public MappingProfiles()
        {
            CreateMap<Product, ProductDto>()
                .ForMember(d => d.ProductBrand, o => o.MapFrom(s => s.ProductBrand.Name))
                .ForMember(d => d.ProductType, o => o.MapFrom(s => s.ProductType.Name))
                .ForMember(d => d.PictureUrl, o => o.MapFrom<ProductUrlResolver>());
            CreateMap<ProductUpsertObject, Product>();
            CreateMap<Photo, PhotoDto>()
                .ForMember(d => d.PictureUrl, o => o.MapFrom<PhotoUrlResolver>());
            CreateMap<AddressUpsertObject, Address>().ReverseMap();
            CreateMap<AddressDto, Address>().ReverseMap();
            CreateMap<AppUser, AppUserDto>()
            .ForMember(d => d.PictureUrl, o => o.MapFrom<AppUserUrlResolver>())
            .ForMember(d => d.Roles, opt => opt.MapFrom(s => s.UserRoles.Select(ur => ur.Role.Name).ToList()));
            CreateMap<ServiceUpsertObject, Service>();
        }
    }
}