using AutoMapper;
using Core.Interfaces;
using Core.Models.SearchObjects;

namespace Infrastructure.Data.Repositories
{
    public class BaseCRUDService<T, TDb, TSearch, TInsert, TUpdate> : BaseService<T, TDb, TSearch>,
        ICRUDService<T, TSearch, TInsert, TUpdate>
        where T : class where TDb : class where TSearch : BaseSearchObject
    {
        public BaseCRUDService(BarbershopContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public virtual Task BeforeInsert(TDb entity, TInsert insert)
        {
            return Task.CompletedTask;
        }
        

        public virtual async Task<T> Insert(TInsert insert)
        {
            var set = _context.Set<TDb>();

            TDb entity = _mapper.Map<TDb>(insert);

            set.Add(entity);
            await BeforeInsert(entity, insert);

            await _context.SaveChangesAsync();
            return _mapper.Map<T>(entity);
        }


        public virtual async Task<T> Update(int id, TUpdate update)
        {
            var set = _context.Set<TDb>();

            var entity = await set.FindAsync(id);

            _mapper.Map(update, entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<T>(entity);
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
    }
}