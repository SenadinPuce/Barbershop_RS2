using Core.Entities;
using Core.Models.SearchObjects;
using Core.Models.UpsertObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Core.Interfaces
{
	public interface IFITPasosService : ICRUDService<FITPasos, FITPasosSearchObject, FITPasosUpsertObject, FITPasosUpsertObject>
	{
	}
}
