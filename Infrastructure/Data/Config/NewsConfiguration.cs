using Core.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Data.Config
{
    public class NewsConfiguration : IEntityTypeConfiguration<News>
    {
        public void Configure(EntityTypeBuilder<News> builder)
        {
            builder.HasOne(n => n.Author).WithMany().HasForeignKey(n => n.AuthorId).OnDelete(DeleteBehavior.ClientSetNull);
        }
    }
}