using Core.Entities;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;

namespace Core.Interfaces
{
    public interface ITermService : ICRUDService<Term, TermSearchObject, TermUpsertObject, TermUpsertObject>
    {
        
    }
}