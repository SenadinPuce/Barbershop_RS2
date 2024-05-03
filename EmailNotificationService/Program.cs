using System.Net;
using System.Net.Mail;
using EasyNetQ;
using Core;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddSingleton<IBus>(serviceProvider =>
{
    var hostName = Environment.GetEnvironmentVariable("RabbitMQ_HostName") ?? "localhost";
    var userName = Environment.GetEnvironmentVariable("RabbitMQ_UserName") ?? "guest";
    var password = Environment.GetEnvironmentVariable("RabbitMQ_Password") ?? "guest";

    var connectionString = $"host={hostName};username={userName};password={password}";
    return RabbitHutch.CreateBus(connectionString);
});

builder.Services.AddHostedService<RabbitMQSubscriberService>();

var app = builder.Build();

app.Run();
