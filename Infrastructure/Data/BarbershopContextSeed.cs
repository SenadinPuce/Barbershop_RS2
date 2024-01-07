using System.Reflection;
using System.Text.Json;
using Core.Entities;
using Core.Entities.OrderAggregate;
using Microsoft.AspNetCore.Identity;

namespace Infrastructure.Data
{
    public class BarbershopContextSeed
    {
        public static async Task SeedAsync(BarbershopContext context, UserManager<AppUser> userManager,
            RoleManager<AppRole> roleManager)
        {
            var path = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);

            if (!context.ProductBrands.Any())
            {
                var brandsData = File.ReadAllText(path + @"/Data/SeedData/brands.json");
                var brands = JsonSerializer.Deserialize<List<ProductBrand>>(brandsData);
                context.ProductBrands.AddRange(brands);
            }

            if (!context.ProductTypes.Any())
            {
                var typesData = File.ReadAllText(path + @"/Data/SeedData/types.json");
                var types = JsonSerializer.Deserialize<List<ProductType>>(typesData);
                context.ProductTypes.AddRange(types);
            }

            if (!context.Products.Any())
            {
                var productsData = File.ReadAllText(path + @"/Data/SeedData/products.json");
                var products = JsonSerializer.Deserialize<List<ProductSeedModel>>(productsData);

                foreach (var item in products)
                {
                    var pictureFileName = item.PictureUrl.Substring(16);
                    var product = new Product
                    {
                        Name = item.Name,
                        Description = item.Description,
                        Price = item.Price,
                        ProductBrandId = item.ProductBrandId,
                        ProductTypeId = item.ProductTypeId
                    };
                    product.AddPhoto(item.PictureUrl, pictureFileName);
                    context.Products.Add(product);
                }

            }

            if (!context.DeliveryMethods.Any())
            {
                var deliveryData = File.ReadAllText(path + @"/Data/SeedData/delivery.json");
                var methods = JsonSerializer.Deserialize<List<DeliveryMethod>>(deliveryData);
                context.DeliveryMethods.AddRange(methods);
            }

            if (!context.Services.Any())
            {
                var servicesData = File.ReadAllText(path + @"/Data/SeedData/services.json");
                var services = JsonSerializer.Deserialize<List<Service>>(servicesData);
                context.Services.AddRange(services);
            }

            if (!context.Addresses.Any())
            {
                var addressesData = File.ReadAllText(path + @"/Data/SeedData/addresses.json");
                var addresses = JsonSerializer.Deserialize<List<Address>>(addressesData);

                foreach (var item in addresses)
                {
                    Console.WriteLine(item.FirstName);
                }
                context.Addresses.AddRange(addresses);
            }

            // Users seed

            if (!userManager.Users.Any())
            {
                var users = new List<AppUser>
                {
                    new AppUser
                    {
                        FirstName = "Test",
                        LastName = "Test",
                        Email = "test@test.com",
                        UserName = "test",
                        Address = new Address
                        {
                            FirstName = "First name test",
                            LastName = "Last name test",
                            Street = "Sjeverni logor bb",
                            City = "Mostar",
                            State = "BiH",
                            ZipCode = "88000"
                        }
                    },
                     new AppUser
                    {
                        FirstName = "John",
                        LastName = "Doe",
                        Email= "john@test.com",
                        UserName = "john"
                    },
                    new AppUser
                    {
                        FirstName = "Admin",
                        LastName = "Admin",
                        Email= "admin@test.com",
                        UserName = "admin"
                    }
                };

                var roles = new List<AppRole>
                {
                    new AppRole{ Name = "Client"},
                    new AppRole{ Name = "Barber"},
                    new AppRole{ Name= "Admin"}
                };

                foreach (var role in roles)
                {
                    await roleManager.CreateAsync(role);
                };

                foreach (var user in users)
                {
                    await userManager.CreateAsync(user, "Pa$$w0rd");
                    if (user.UserName == "test") await userManager.AddToRoleAsync(user, "Client");
                    if (user.UserName == "john") await userManager.AddToRoleAsync(user, "Barber");
                    if (user.UserName == "admin") await userManager.AddToRoleAsync(user, "Admin");
                }
            }

            if (!context.Orders.Any())
            {
                var ordersData = File.ReadAllText(path + @"/Data/SeedData/orders.json");
                var orders = JsonSerializer.Deserialize<List<Order>>(ordersData);
                context.Orders.AddRange(orders);
            }


            if (context.ChangeTracker.HasChanges()) await context.SaveChangesAsync();
        }
    }
}