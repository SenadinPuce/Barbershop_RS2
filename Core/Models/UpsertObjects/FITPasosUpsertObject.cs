using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Core.Models.UpsertObjects
{
	public class FITPasosUpsertObject
	{
        public int KorisnikId { get; set; }
        public DateTime DatumVazenja { get; set; }
        public bool IsValid { get; set; }
    }
}
