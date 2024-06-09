using Core.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Data.Config
{
    public class ReviewConfiguration : IEntityTypeConfiguration<Review>
    {
        public void Configure(EntityTypeBuilder<Review> builder)
        {
            builder.HasOne(r => r.Client).WithMany().HasForeignKey(r => r.ClientId).IsRequired().OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(r => r.Barber).WithMany().HasForeignKey(r => r.BarberId).IsRequired().OnDelete(DeleteBehavior.NoAction);
        }
    }
}