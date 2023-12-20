namespace Core.Entities.OrderAggregate
{
	public class Order
	{
		public Order()
		{
		}

		public Order(ICollection<OrderItem> orderItems, string buyerEmail, Address shipToAddress,
		   DeliveryMethod deliveryMethod, decimal subtotal, string paymentIntentId, User client)
		{
			ShipToAddress = shipToAddress;
			Client = client;
			DeliveryMethod = deliveryMethod;
			OrderItems = orderItems;
			Subtotal = subtotal;
			PaymentIntentId = paymentIntentId;
		}

		public int Id { get; set; }
		public int ClientId { get; set; }
		public User Client { get; set; }
		public DateTime OrderDate { get; set; } = DateTime.UtcNow;
		public int ShipToAddressId { get; set; }
		public Address ShipToAddress { get; set; }
		public int DeliveryMethodId { get; set; }
		public DeliveryMethod DeliveryMethod { get; set; }
		public ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
		public decimal Subtotal { get; set; }
		public OrderStatus Status { get; set; } = OrderStatus.Pending;
		public string PaymentIntentId { get; set; }
	}
}