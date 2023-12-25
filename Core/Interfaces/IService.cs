namespace Core.Interfaces
{
    public interface IService<TDb, TSearch>
    {
        Task<List<TDb>> GetAsync(TSearch search);
        Task<TDb> GetByIdAsync(int id);
    }
}