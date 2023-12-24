namespace Core.Interfaces
{
    public interface IService<T, TSearch>
    {
        Task<List<T>> GetAsync(TSearch search);
        Task<T> GetByIdAsync(int id);
    }
}