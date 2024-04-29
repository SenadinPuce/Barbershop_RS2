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

        public void SendMessage<T>(T obj)
        {
            try
            {
                var hostName = Environment.GetEnvironmentVariable("RabbitMQ_HostName") ?? "rabbitmq";
                var userName = Environment.GetEnvironmentVariable("RabbitMQ_UserName") ?? "guest";
                var password = Environment.GetEnvironmentVariable("RabbitMQ_Password") ?? "guest";

                var connectionString = $"host={hostName};username={userName};password={password}";

                _logger.LogInformation($"Connecting to RabbitMQ with connection string: {connectionString}");

                using var bus = RabbitHutch.CreateBus(connectionString);
                bus.PubSub.Publish(obj);
            }
            catch (TaskCanceledException ex)
            {
                _logger.LogError(ex, "Task was canceled during message publishing");
            }
            catch (OperationCanceledException ex)
            {
                _logger.LogError(ex, "Task was canceled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message, "An error occurred while establishing a connection to the RabbitMQ server");
            }
        }
    }
}