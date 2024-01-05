using AutoMapper;
using Core.Interfaces;
using Core.Models.SearchObjects;

namespace Infrastructure.Data.Repositories
{
    public class BaseCRUDService<TDb, TSearch, TInsert, TUpdate> : BaseService<TDb, TSearch>,
        ICRUDService<TDb, TSearch, TInsert, TUpdate>
        where TDb : class where TSearch : BaseSearchObject
    {
        protected readonly IMapper _mapper;
        public BaseCRUDService(BarbershopContext context, IMapper mapper) : base(context)
        {
            _mapper = mapper;
        }

        public virtual async Task<TDb> Insert(TInsert insert)
        {
            var set = _context.Set<TDb>();

            TDb entity = _mapper.Map<TDb>(insert);

            await BeforeInsert(entity, insert);
            set.Add(entity);

            await _context.SaveChangesAsync();

            return entity;
        }


        public virtual async Task<TDb> Update(int id, TUpdate update)
        {
            var set = _context.Set<TDb>();

            var entity = await set.FindAsync(id);
            
            _mapper.Map(update, entity);

            await _context.SaveChangesAsync();
            return entity;
        }

        public virtual async Task<bool> Delete(int id)
        {
            var set = _context.Set<TDb>();

            var entity = set.Find(id);

            if (entity != null)
            {
                set.Remove(entity);
                await _context.SaveChangesAsync();
                return true;
            }
            return false;
        }

        public virtual Task BeforeInsert(TDb entity, TInsert insert)
        {
            return Task.CompletedTask;
        }
    }
}