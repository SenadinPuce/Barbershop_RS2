using API.Dtos;
using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.InsertObjects;
using Core.Models.SearchObjects;
using Core.Models.UpdateObjects;

namespace API.Controllers
{
    public class NewsController : BaseCRUDController<NewsDto, News, NewsSearchObject, NewsInsertObject, NewsUpdateObject>
    {
        public NewsController(INewsService service, IMapper mapper) : base(service, mapper)
        {
        }
    }
}