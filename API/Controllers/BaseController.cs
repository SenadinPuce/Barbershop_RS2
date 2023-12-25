using AutoMapper;
using Core.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class BaseController<T, TDb, TSearch> : ControllerBase
        where T : class where TDb : class where TSearch : class
    {
        private readonly IService<TDb, TSearch> _service;
        private readonly IMapper _mapper;
        public BaseController(IService<TDb, TSearch> service, IMapper mapper)
        {
            _mapper = mapper;
            _service = service;
        }

        [HttpGet]
        public virtual async Task<ActionResult<IReadOnlyList<T>>> Get([FromQuery] TSearch search)
        {
            var list = await _service.GetAsync(search);

            return Ok(_mapper.Map<List<T>>(list));
        }

        [HttpGet("{id}")]
        public virtual async Task<ActionResult<T>> GetById(int id)
        {
            var entity = await _service.GetByIdAsync(id);

            return Ok(_mapper.Map<T>(entity));
        }
    }
}