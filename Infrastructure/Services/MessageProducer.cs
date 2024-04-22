using Core.Interfaces;
using EasyNetQ;
using Microsoft.Extensions.Configuration;
using RabbitMQ.Client;

namespace Infrastructure.Services
{
    public class MessageProducer : IMessageProducer
    {
        private readonly IConfiguration _config;
        public MessageProducer(IConfiguration config)
        {
            _config = config;
        }

        public void SendMessage<T>(T obj)
        {
            var rabbitMQConfig = _config.GetSection("RabbitMQ");
            var hostName = rabbitMQConfig["HostName"];
            var userName = rabbitMQConfig["UserName"];
            var password = rabbitMQConfig["Password"];

            var connectionString = $"host={hostName};username={userName};password={password}";

            using var bus = RabbitHutch.CreateBus(connectionString);
            bus.PubSub.Publish(obj);
        }
    }
}