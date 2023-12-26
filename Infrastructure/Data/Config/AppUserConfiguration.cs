using System.IO.Compression;
using Core.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Data.Config
{
    public class AppUserConfiguration : IEntityTypeConfiguration<AppUser>
    {
        public void Configure(EntityTypeBuilder<AppUser> builder)
        {
            builder.HasMany(ur => ur.UserRoles).WithOne(u => u.User).HasForeignKey(ur => ur.UserId);
            builder.HasOne(u => u.Address).WithOne().HasForeignKey<AppUser>(u => u.AddressId).OnDelete(DeleteBehavior.Cascade);
        }
    }
}