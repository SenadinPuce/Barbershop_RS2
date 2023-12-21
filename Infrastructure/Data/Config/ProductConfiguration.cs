using Core.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Data.Config
{
    public class ProductConfiguration : IEntityTypeConfiguration<Product>
{
    public void Configure(EntityTypeBuilder<Product> builder)
    {
        builder.HasMany(p => p.Photos).WithOne(ph => ph.Product).HasForeignKey(ph => ph.ProductId);
        builder.Property(x => x.Price).HasColumnType("decimal(18,2)").IsRequired();
    }
}
}