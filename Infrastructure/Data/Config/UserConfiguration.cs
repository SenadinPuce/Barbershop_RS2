using Core.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Data.Config
{
    public class UserConfiguration : IEntityTypeConfiguration<User>
    {
        public void Configure(EntityTypeBuilder<User> builder)
        {
            builder.HasOne(u => u.Photo).WithOne().HasForeignKey<User>(u => u.PhotoId).OnDelete(DeleteBehavior.Cascade);
            builder.HasOne(u => u.Address).WithOne().HasForeignKey<User>(u => u.AddressId).OnDelete(DeleteBehavior.Cascade);
        }
    }
}