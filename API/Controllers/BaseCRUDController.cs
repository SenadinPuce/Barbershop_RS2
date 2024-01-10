using AutoMapper;
using Core.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    // out for development
    // [Authorize]
    public class BaseCRUDController<T, TDb, TSearch, TInsert, TUpdate> : BaseController<T, TDb, TSearch>
        where T : class where TDb : class where TSearch : class
    {
        private readonly ICRUDService<TDb, TSearch, TInsert, TUpdate> _service;
        private readonly IMapper _mapper;
        public BaseCRUDController(ICRUDService<TDb, TSearch, TInsert, TUpdate> service, IMapper mapper)
        : base(service, mapper)
        {
            _mapper = mapper;
            _service = service;
        }

        [HttpPost]
        public virtual async Task<ActionResult<T>> Post([FromBody] TInsert insert)
        {
            if (insert == null) return BadRequest();

            var created = await _service.Insert(insert);

            return Ok(_mapper.Map<T>(created));
        }

        [HttpPut("{id}")]
        public virtual async Task<ActionResult<T>> Put(int id, [FromBody] TUpdate insert)
        {
            if (insert == null) return BadRequest();

            var updated = await _service.Update(id, insert);

            return Ok(_mapper.Map<T>(updated));
        }


        [HttpDelete("{id}")]
        public virtual async Task<ActionResult> Delete(int id)
        {
            var result = await _service.Delete(id);

            if (result != null) return Ok(_mapper.Map<T>(result));

            return BadRequest();
        }
    }
}