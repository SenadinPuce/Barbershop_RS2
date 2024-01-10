namespace Core.Interfaces
{
    public interface ICRUDService<TDb, TSearch, TInsert, TUpdate> : IService<TDb, TSearch>
    {
        Task<TDb> Insert(TInsert insert);
        Task<TDb> Update(int id, TUpdate update);
        Task<TDb> Delete(int id);
    }
}