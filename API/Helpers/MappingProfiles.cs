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
                .ForMember(d => d.ProductType, o => o.MapFrom(s => s.ProductType.Name));
            CreateMap<ProductUpsertObject, Product>();
            CreateMap<AddressUpsertObject, Address>().ReverseMap();
            CreateMap<AddressDto, Address>().ReverseMap();
            CreateMap<AppUser, AppUserDto>()
            .ForMember(d => d.Roles, opt => opt.MapFrom(s => s.UserRoles.Select(ur => ur.Role.Name).ToList()));
            CreateMap<UserUpdateDto, AppUser>()
                .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null)); ;
            CreateMap<UserUpdateRequest, AppUser>();
            CreateMap<ServiceUpsertObject, Service>();
            CreateMap<Service, ServiceDto>();
            CreateMap<AppointmentInsertObject, Appointment>();
            CreateMap<AppointmentUpdateObject, Appointment>();
            CreateMap<Appointment, AppointmentDto>()
          .ForMember(dest => dest.ClientName, opt => opt.MapFrom(src => $"{src.Client.FirstName} {src.Client.LastName}"))
          .ForMember(dest => dest.BarberName, opt => opt.MapFrom(src => $"{src.Term.Barber.FirstName} {src.Term.Barber.LastName}"))
          .ForMember(dest => dest.ServiceName, opt => opt.MapFrom(src => src.Service.Name))
          .ForMember(dest => dest.ServicePrice, opt => opt.MapFrom(src => src.Service.Price))
          .ForMember(dest => dest.Date, opt => opt.MapFrom(src => src.Term.Date))
          .ForMember(dest => dest.StartTime, opt => opt.MapFrom(src => src.Term.StartTime))
          .ForMember(dest => dest.EndTime, opt => opt.MapFrom(src => src.Term.EndTime));
            CreateMap<Order, OrderDto>()
                .ForMember(d => d.ClientFullName, o => o.MapFrom(s => s.Client.FirstName + ' ' + s.Client.LastName))
                .ForMember(d => d.ClientEmail, o => o.MapFrom(s => s.Client.Email))
                .ForMember(d => d.ClientPhoneNumber, o => o.MapFrom(s => s.Client.PhoneNumber));
            CreateMap<OrderItem, OrderItemDto>()
               .ForMember(d => d.Id, o => o.MapFrom(s => s.ProductId))
               .ForMember(d => d.ProductName, o => o.MapFrom(s => s.Product.Name))
               .ForMember(d => d.Photo, o => o.MapFrom(s => s.Product.Photo));
            CreateMap<News, NewsDto>()
                .ForMember(d => d.AuthorFullName, o => o.MapFrom(s => s.Author.FirstName + ' ' + s.Author.LastName));
            CreateMap<NewsInsertObject, News>();
            CreateMap<NewsUpdateObject, News>();
            CreateMap<Review, ReviewDto>()
                .ForMember(d => d.ClientFirstName, o => o.MapFrom(s => s.Client.FirstName))
                .ForMember(d => d.ClientLastName, o => o.MapFrom(s => s.Client.LastName));
            CreateMap<ReviewUpsertObject, Review>();
            CreateMap<DeliveryMethod, DeliveryMethodDto>();
            CreateMap<DeliveryMethodUpsertObject, DeliveryMethod>();
            CreateMap<TermUpsertObject, Term>();
            CreateMap<Term, TermDto>().ForMember(d => d.BarberName, o => o.MapFrom(s => s.Barber.FirstName + ' ' + s.Barber.LastName));
            CreateMap<AppUser, BarberDto>();
        }
    }
}