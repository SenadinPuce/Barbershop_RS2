using Core.Entities.OrderAggregate;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Data.Config
{
    public class OrderConfiguration : IEntityTypeConfiguration<Order>
    {
        public void Configure(EntityTypeBuilder<Order> builder)
        {
            builder.Navigation(o => o.Address).IsRequired();
            builder.Property(o => o.Status)
                .HasConversion(
                    o => o.ToString(),
                    o => (OrderStatus)Enum.Parse(typeof(OrderStatus), o)
                );
            builder.Property(o => o.Subtotal).HasColumnType("decimal(18,2)");

            builder.HasMany(o => o.OrderItems).WithOne(oi => oi.Order).HasForeignKey(oi => oi.OrderId).OnDelete(DeleteBehavior.Cascade);
            builder.HasOne(o => o.Client).WithMany().HasForeignKey(o => o.ClientId).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(o => o.Address).WithOne().HasForeignKey<Order>(o => o.AddressId).OnDelete(DeleteBehavior.Cascade);
        }
    }
}