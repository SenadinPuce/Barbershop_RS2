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
        }
    }
}