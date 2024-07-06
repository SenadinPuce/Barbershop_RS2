using Core.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Data.Config
{
    public class AppointmentConfiguration : IEntityTypeConfiguration<Appointment>
    {
        public void Configure(EntityTypeBuilder<Appointment> builder)
        {
            builder.HasOne(a => a.Client).WithMany().HasForeignKey(a => a.ClientId).OnDelete(DeleteBehavior.ClientSetNull);
            builder.HasOne(a => a.Term).WithMany().HasForeignKey(a => a.TermId).OnDelete(DeleteBehavior.ClientSetNull);
            builder.HasOne(a => a.Service).WithMany().HasForeignKey(a => a.ServiceId).OnDelete(DeleteBehavior.ClientSetNull);
        }
    }
}