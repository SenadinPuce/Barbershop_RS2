using Core.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Data.Config
{
    public class TermConfiguration : IEntityTypeConfiguration<Term>
    {
        public void Configure(EntityTypeBuilder<Term> builder)
        {
            builder.HasOne(t => t.Barber).WithMany().HasForeignKey(t => t.BarberId).OnDelete(DeleteBehavior.ClientSetNull);
        }
    }
}