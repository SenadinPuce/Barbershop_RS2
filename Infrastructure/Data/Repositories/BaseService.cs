using Core.Interfaces;
using Core.Models.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Data.Repositories
{
    public class BaseService<TDb, TSearch> : IService<TDb, TSearch>
       where TDb : class where TSearch : BaseSearchObject
    {
        protected readonly BarbershopContext _context;
        public BaseService(BarbershopContext context)
        {
            _context = context;
        }

        public async Task<List<TDb>> GetAsync(TSearch search)
        {
            var query = _context.Set<TDb>().AsQueryable();

            query = AddFilter(query, search);
            query = AddInclude(query, search);
            query = AddSorting(query, search);

            if (search.PageIndex.HasValue == true && search.PageSize.HasValue == true)
            {
                query = query.Skip((search.PageIndex.Value - 1) * search.PageSize.Value).Take(search.PageSize.Value);
            }

            return await query.ToListAsync();
        }

        public virtual async Task<TDb> GetByIdAsync(int id)
        {
            return await _context.Set<TDb>().FindAsync(id);
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