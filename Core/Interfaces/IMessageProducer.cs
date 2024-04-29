namespace Core.Interfaces
{
    public interface IMessageProducer
    {
        public void SendMessage<T>(T obj);
    }
}