using API.Dtos;
using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;

namespace API.Controllers
{
    public class TermsController : BaseCRUDController<TermDto, Term, TermSearchObject, TermUpsertObject, TermUpsertObject>
    {
        public TermsController(ITermService service, IMapper mapper) : base(service, mapper)
        {
        }
    }
}