using Core.Entities;
using Core.Models.InsertObjects;
using Core.Models.SearchObjects;
using Core.Models.UpdateObjects;

namespace Core.Interfaces
{
    public interface INewsService : ICRUDService<News, NewsSearchObject, NewsInsertObject, NewsUpdateObject>
    {

    }
}