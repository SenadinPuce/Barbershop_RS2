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
            builder.Property(x => x.DurationInMinutes).IsRequired();
            builder.Property(x => x.Status).HasConversion(
                o => o.ToString(),
                o => (AppointmentStatus)Enum.Parse(typeof(AppointmentStatus), o)).IsRequired();

            builder.HasOne(x => x.Barber).WithMany().HasForeignKey(x => x.BarberId).OnDelete(DeleteBehavior.NoAction).IsRequired();
            builder.HasOne(x => x.Client).WithMany().HasForeignKey(x => x.ClientId).OnDelete(DeleteBehavior.SetNull);
            builder.HasOne(x => x.Service).WithOne().HasForeignKey<Appointment>(x => x.ServiceId).OnDelete(DeleteBehavior.SetNull);
        }
    }
}