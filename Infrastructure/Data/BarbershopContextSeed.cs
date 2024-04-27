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
                var products = JsonSerializer.Deserialize<List<Product>>(productsData);
                context.Products.AddRange(products);
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
                context.Addresses.AddRange(addresses);
            }

            // Users seed

            if (!userManager.Users.Any())
            {
                var users = new List<AppUser>
                {
                    new AppUser
                    {
                        FirstName = "User",
                        LastName = "User",
                        Email = "user@test.com",
                        PhoneNumber = "061-111-111",
                        UserName = "user",
                        Address = new Address
                        {
                            FirstName = "First name user",
                            LastName = "Last name user",
                            Street = "Sjeverni logor bb",
                            City = "Mostar",
                            State = "BiH",
                            ZipCode = "88000"
                        }
                    },
                     new AppUser
                    {
                        FirstName = "Barber1",
                        LastName = "Barber1",
                        Email= "barber1@test.com",
                        PhoneNumber = "061-222-222",
                        UserName = "barber1"
                    },
                        new AppUser
                    {
                        FirstName = "Barber2",
                        LastName = "Barber2",
                        Email= "barber2@test.com",
                        PhoneNumber = "061-333-333",
                        UserName = "barber2"
                    },
                    new AppUser
                    {
                        FirstName = "Admin",
                        LastName = "Admin",
                        Email= "admin@test.com",
                        PhoneNumber = "061-444-444",
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
                    if (user.UserName == "user") await userManager.AddToRoleAsync(user, "Client");
                    if (user.UserName == "barber1" || user.UserName == "barber2") await userManager.AddToRoleAsync(user, "Barber");
                    if (user.UserName == "admin") await userManager.AddToRoleAsync(user, "Admin");
                }
            }

            if (!context.Reviews.Any())
            {
                var reviewsData = File.ReadAllText(path + @"/Data/SeedData/reviews.json");
                var reviews = JsonSerializer.Deserialize<List<Review>>(reviewsData);
                context.Reviews.AddRange(reviews);
            }

            if (!context.News.Any())
            {
                var newsData = File.ReadAllText(path + @"/Data/SeedData/news.json");
                var news = JsonSerializer.Deserialize<List<News>>(newsData);
                context.News.AddRange(news);
            }

            if (!context.Orders.Any())
            {
                var ordersData = File.ReadAllText(path + @"/Data/SeedData/orders.json");
                var orders = JsonSerializer.Deserialize<List<Order>>(ordersData);
                orders.Find(o => o.PaymentIntentId == "payment_intent_3").Status = OrderStatus.PaymentReceived;
                orders.Find(o => o.PaymentIntentId == "payment_intent_4").Status = OrderStatus.PaymentReceived;

                context.Orders.AddRange(orders);
            }

            if (!context.Appointments.Any())
            {
                var appointmentsData = File.ReadAllText(path + @"/Data/SeedData/appointments.json");
                var appointments = JsonSerializer.Deserialize<List<AppointmentModel>>(appointmentsData);

                foreach (var appointmentData in appointments)
                {
                    var appointment = new Appointment
                    {
                        StartTime = appointmentData.StartTime,
                        BarberId = appointmentData.BarberId,
                        ClientId = appointmentData.ClientId,
                        AppointmentServices = new List<AppointmentService>()
                    };


                    foreach (var serviceId in appointmentData.ServiceIds)
                    {
                        Service service = await context.Services.FindAsync(serviceId);

                        if (service != null)
                        {
                            var appointmentService = new AppointmentService
                            {
                                Appointment = appointment,
                                ServiceId = service.Id,
                                Service = service
                            };
                            appointment.AppointmentServices.Add(appointmentService);
                        }

                    }
                    context.Appointments.Add(appointment);
                }

            }


            if (context.ChangeTracker.HasChanges()) await context.SaveChangesAsync();
        }
    }
}