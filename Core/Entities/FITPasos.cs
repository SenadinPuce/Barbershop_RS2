using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Core.Entities
{
	public class FITPasos
	{
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public AppUser Korisnik { get; set; }
        public DateTime DatumIzdavanje { get; set; } = DateTime.UtcNow;
        public DateTime DatumeVazenja { get; set; }
        public bool IsValid { get; set; }
    }
}