using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.InsertObjects;
using Core.Models.SearchObjects;
using Core.Models.UpdateObjects;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Data.Repositories
{
    public class NewsService : BaseCRUDService<News, NewsSearchObject, NewsInsertObject, NewsUpdateObject>, INewsService
    {
        public NewsService(BarbershopContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<News> AddFilter(IQueryable<News> query, NewsSearchObject search)
        {
            if (!string.IsNullOrWhiteSpace(search.Title))
            {
                query = query.Where(n => n.Title.Contains(search.Title));
            }

            return query;
        }

        public override IQueryable<News> AddInclude(IQueryable<News> query, NewsSearchObject search)
        {
            if (search.IncludeAuthor)
            {
                query = query.Include(n => n.Author);
            }
            return query;
        }
    }
}