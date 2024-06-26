using Core.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Data.Config
{
    public class AppointmentConfiguration : IEntityTypeConfiguration<Appointment>
    {
        public void Configure(EntityTypeBuilder<Appointment> builder)
        {
            builder.Property(x => x.StartTime).IsRequired();
            builder.Property(x => x.Status).HasConversion(
                o => o.ToString(),
                o => (AppointmentStatus)Enum.Parse(typeof(AppointmentStatus), o)).IsRequired();

            builder.HasOne(x => x.Barber).WithMany().HasForeignKey(x => x.BarberId).IsRequired().OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(x => x.Client).WithMany().HasForeignKey(x => x.ClientId).IsRequired().OnDelete(DeleteBehavior.NoAction);
        }
    }
}