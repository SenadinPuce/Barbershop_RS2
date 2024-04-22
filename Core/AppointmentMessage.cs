namespace Core
{
    public class AppointmentMessage
    {
        public int AppointmentId { get; set; }
        public string ClientEmail { get; set; }
        public string Service { get; set; }
        public string BarberFullName { get; set; }
        public string DateTime { get; set; }
    }
}