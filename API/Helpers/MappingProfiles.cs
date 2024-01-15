using API.Dtos;
using AutoMapper;
using Core.Entities;
using Core.Entities.OrderAggregate;
using Core.Models.InsertObjects;
using Core.Models.UpdateObjects;
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
            CreateMap<AppointmentInsertObject, Appointment>();
            CreateMap<AppointmentUpdateObject, Appointment>();
            CreateMap<Appointment, AppointmentDto>()
                .ForMember(d => d.BarberUsername, o => o.MapFrom(s => s.Barber.UserName))
                .ForMember(d => d.ClientUsername, o => o.MapFrom(s => s.Client.UserName))
                .ForMember(d => d.ServiceName, o => o.MapFrom(s => s.Service.Name))
                .ForMember(d => d.ServicePrice, o => o.MapFrom(s => s.Service.Price));
            CreateMap<Order, OrderDto>()
                .ForMember(d => d.ClientUsername, o => o.MapFrom(s => s.Client.UserName))
                .ForMember(d => d.ClientEmail, o => o.MapFrom(s => s.Client.Email))
                .ForMember(d => d.ClientPhoneNumber, o => o.MapFrom(s => s.Client.PhoneNumber));
            CreateMap<OrderItem, OrderItemDto>()
               .ForMember(d => d.Id, o => o.MapFrom(s => s.ItemOrdered.ProductItemId))
               .ForMember(d => d.ProductName, o => o.MapFrom(s => s.ItemOrdered.ProductName))
               .ForMember(d => d.PictureUrl, o => o.MapFrom<OrderItemUrlResolver>());

        }
    }
}