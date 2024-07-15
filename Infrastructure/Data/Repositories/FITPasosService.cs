using AutoMapper;
using Core.Entities;
using Core.Interfaces;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Data.Repositories
{
	public class FITPasosService : BaseCRUDService<FITPasos, FITPasosSearchObject, FITPasosUpsertObject, FITPasosUpsertObject>, IFITPasosService
	{
		public FITPasosService(BarbershopContext context, IMapper mapper) : base(context, mapper)
		{
		}

		public override IQueryable<FITPasos> AddFilter(IQueryable<FITPasos> query, FITPasosSearchObject search)
		{
			if (search.KorisnikId.HasValue)
			{
				query = query.Where(x => x.KorisnikId == search.KorisnikId.Value);
			}
			if (search.DatumVazenjaOd.HasValue)
			{
				query = query.Where(x => x.DatumeVazenja.Date >= search.DatumVazenjaOd.Value.Date);
			}
			if(search.DatumVaznjenjaDo.HasValue)
			{
				query = query.Where(x => x.DatumeVazenja.Date <= search.DatumVaznjenjaDo.Value.Date);
			}

			return query;
		}

		public override IQueryable<FITPasos> AddInclude(IQueryable<FITPasos> query, FITPasosSearchObject search)
		{
			if (search.IncludeKorisnik)
			{
				query = query.Include(x => x.Korisnik);
			}
			return query;
		}
	}
}
