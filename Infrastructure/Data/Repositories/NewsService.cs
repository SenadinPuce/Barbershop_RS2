using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.InsertObjects;
using Core.Models.SearchObjects;
using Core.Models.UpdateObjects;

namespace Infrastructure.Data.Repositories
{
    public class NewsService : BaseCRUDService<News, NewsSearchObject, NewsInsertObject, NewsUpdateObject>, INewsService
    {
        public NewsService(BarbershopContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}