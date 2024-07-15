using API.Dtos;
using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;

namespace API.Controllers
{
	public class FITPasosController : BaseCRUDController<FITPasosDto, FITPasos, FITPasosSearchObject, FITPasosUpsertObject, FITPasosUpsertObject>
	{
		public FITPasosController(IFITPasosService service, IMapper mapper) : base(service, mapper)
		{
		}
	}
}
