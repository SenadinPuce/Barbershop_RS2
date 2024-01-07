namespace Core.Entities.OrderAggregate
{
	public partial class Order
	{
		public Order()
		{
		}

		public Order(ICollection<OrderItem> orderItems, int clientId,
		   DeliveryMethod deliveryMethod, decimal subtotal, string paymentIntentId, Address address)
		{
			ClientId = clientId;
			DeliveryMethod = deliveryMethod;
			OrderItems = orderItems;
			Subtotal = subtotal;
			PaymentIntentId = paymentIntentId;
			Address = address;
		}

		public int Id { get; set; }

		public int ClientId { get; set; }
		public virtual AppUser Client { get; set; }
		public DateTime OrderDate { get; set; } = DateTime.UtcNow;
		public int AddressId { get; set; }
		public virtual Address Address { get; set; }
		public int DeliveryMethodId { get; set; }
		public virtual DeliveryMethod DeliveryMethod { get; set; }

		public virtual ICollection<OrderItem> OrderItems { get; set; }
		public decimal Subtotal { get; set; }
		public OrderStatus Status { get; set; } = OrderStatus.Pending;
		public string PaymentIntentId { get; set; }

		public decimal GetTotal()
		{
			return Subtotal + DeliveryMethod.Price;
		}
	}
}