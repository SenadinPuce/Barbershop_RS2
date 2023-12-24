using AutoMapper;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Data.Repositories
{
    public class BaseService<T, TDb, TSearch> : IService<T, TSearch>
        where T : class where TDb : class where TSearch : BaseSearchObject
    {
        protected readonly BarbershopContext _context;
        protected readonly IMapper _mapper;
        public BaseService(BarbershopContext context, IMapper mapper)
        {
            _mapper = mapper;
            _context = context;
        }

        public async Task<List<T>> GetAsync(TSearch search)
        {
            var query = _context.Set<TDb>().AsQueryable();

            query = AddFilter(query, search);
            query = AddInclude(query, search);
            query = AddSorting(query, search);

            if (search.PageIndex.HasValue == true && search.PageSize.HasValue == true)
            {
                query = query.Skip((search.PageIndex.Value - 1) * search.PageSize.Value).Take(search.PageSize.Value);
            }

            var list = await query.ToListAsync();

            return _mapper.Map<List<T>>(list);
        }

        public virtual async Task<T> GetByIdAsync(int id)
        {
            var entity = await _context.Set<TDb>().FindAsync(id);

            return _mapper.Map<T>(entity);
        }

        public virtual IQueryable<TDb> AddInclude(IQueryable<TDb> query, TSearch search)
        {
            return query;
        }

        public virtual IQueryable<TDb> AddFilter(IQueryable<TDb> query, TSearch search)
        {
            return query;
        }

        public virtual IQueryable<TDb> AddSorting(IQueryable<TDb> query, TSearch search)
        {
            return query;
        }
    }
}