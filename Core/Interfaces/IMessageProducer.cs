namespace Core.Interfaces
{
    public interface IMessageProducer
    {
        public Task SendMessage<T>(T obj);
    }
}