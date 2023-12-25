using Core.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    // out for development
    // [Authorize]
    public class BaseCRUDController<T, TSearch, TInsert, TUpdate> : BaseController<T, TSearch>
        where T : class where TSearch : class
    {
        private readonly ICRUDService<T, TSearch, TInsert, TUpdate> _service;
        public BaseCRUDController(ICRUDService<T, TSearch, TInsert, TUpdate> service)
        : base(service)
        {
            _service = service;
        }

        [HttpPost]
        public virtual async Task<ActionResult<T>> Post([FromBody] TInsert insert)
        {
            if (insert == null) return BadRequest();

            var created = await _service.Insert(insert);

            return Ok(created);
        }

        [HttpPut("{id}")]
        public virtual async Task<ActionResult<T>> Put(int id, [FromBody] TUpdate insert)
        {
            if (insert == null) return BadRequest();

            var updated= await _service.Update(id, insert);

            return Ok(updated);
        }


        [HttpDelete("{id}")]
        public virtual async Task<ActionResult> Delete(int id)
        {
            var result = await _service.Delete(id);

            if (result == true) return Ok();

            return BadRequest();
        }
    }
}