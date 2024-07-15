namespace Core.Models.SearchObjects
{
	public class FITPasosSearchObject : BaseSearchObject
	{
		public int? KorisnikId { get; set; }
		public DateTime? DatumVazenjaOd { get; set; }
		public DateTime? DatumVaznjenjaDo { get; set; }
		public bool IncludeKorisnik { get; set; } = true;
	}
}
