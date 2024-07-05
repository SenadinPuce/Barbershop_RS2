using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Data.Repositories
{
    public class TermService : BaseCRUDService<Term, TermSearchObject, TermUpsertObject, TermUpsertObject>, ITermService
    {
        public TermService(BarbershopContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override async Task<Term> Update(int id, TermUpsertObject update)
        {
            var term = await _context.Terms.FindAsync(id);

            if (!term.IsBooked)
            {
                return await base.Update(id, update);
            }

            return null;
        }

        public override async Task<Term> Delete(int id)
        {
            var term = await _context.Terms.FindAsync(id);

            if (!term.IsBooked)
            {
                return await base.Delete(id);
            }

            return null;

        }

        public override IQueryable<Term> AddInclude(IQueryable<Term> query, TermSearchObject search)
        {
            if (search.IncludeBarber)
            {
                query = query.Include(t => t.Barber);
            }
            return query;
        }



        public override IQueryable<Term> AddFilter(IQueryable<Term> query, TermSearchObject search)
        {
            if (search.BarberId.HasValue)
            {
                query = query.Where(t => t.BarberId == search.BarberId);
            }
            if (search.Date.HasValue)
            {
                query = query.Where(t => t.Date.Date == search.Date.Value.Date);
            }
            return query;
        }
    }
}