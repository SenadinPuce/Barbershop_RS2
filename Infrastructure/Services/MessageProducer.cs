using Core.Interfaces;
using EasyNetQ;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace Infrastructure.Services
{
    public class MessageProducer : IMessageProducer
    {
        private readonly IConfiguration _config;
        private readonly ILogger<MessageProducer> _logger;
        public MessageProducer(IConfiguration config, ILogger<MessageProducer> logger)
        {
            _logger = logger;
            _config = config;
        }

        public async Task SendMessage<T>(T obj)
        {
            try
            {
                var rabbitMQConfig = _config.GetSection("RabbitMQ");
                var hostName = rabbitMQConfig["HostName"];
                var userName = rabbitMQConfig["UserName"];
                var password = rabbitMQConfig["Password"];

                var connectionString = $"host={hostName};username={userName};password={password}";

                using var bus = RabbitHutch.CreateBus(connectionString);
                await bus.PubSub.PublishAsync(obj);
            }
            catch (Exception ex)
            {
                _logger.LogInformation(ex.Message, "An error occurred while establishing a connection to the RabbitMQ server");
            }
        }
    }
}