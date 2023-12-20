using Core.Entities.OrderAggregate;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Data.Config
{
    public class OrderConfiguration : IEntityTypeConfiguration<Order>
    {
        public void Configure(EntityTypeBuilder<Order> builder)
        {
            builder.Navigation(o => o.ShipToAddress).IsRequired();
            builder.Property(o => o.Status)
                .HasConversion(
                    o => o.ToString(),
                    o => (OrderStatus)Enum.Parse(typeof(OrderStatus), o)
                );
            builder.Property(o => o.Subtotal).HasColumnType("decimal(18,2)");

            builder.HasMany(o => o.OrderItems).WithOne().OnDelete(DeleteBehavior.Cascade);
            builder.HasOne(o => o.ShipToAddress).WithOne().HasForeignKey<Order>(o => o.ShipToAddressId).OnDelete(DeleteBehavior.Cascade);
            builder.HasOne(o => o.Client).WithMany().HasForeignKey(o => o.ClientId).OnDelete(DeleteBehavior.NoAction);
        }
    }
}