namespace Core.Entities
{
    public partial class User
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string Username { get; set; }
        public string PasswordHash { get; set; }
        public string PasswordSalt { get; set; }

        public int? PhotoId { get; set; }
        public virtual Photo Photo { get; set; }

        public int? AddressId { get; set; }
        public virtual Address Address { get; set; }
        
        public virtual ICollection<UserRole> UserRoles { get; set; }
    }
}