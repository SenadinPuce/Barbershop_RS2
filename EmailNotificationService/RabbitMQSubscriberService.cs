using EasyNetQ;
using Core;
using System.Net;
using System.Net.Mail;

public class RabbitMQSubscriberService : BackgroundService
{
	private readonly IBus _bus;

	public RabbitMQSubscriberService(IBus bus)
	{
		_bus = bus;
	}

	protected override async Task ExecuteAsync(CancellationToken stoppingToken)
	{
		while (true)
		{
			try
			{
				_bus.PubSub.Subscribe<AppointmentMessage>("mail_service", async appointment => await HandleMessageAsync(appointment));
				Console.WriteLine("Listening for messages.");
				break;
			}
			catch (Exception ex)
			{
				Console.WriteLine($"An error occurred while subscribing to RabbitMQ: {ex.Message}");

			}
		}
		await Task.CompletedTask;
	}

	private async Task HandleMessageAsync(AppointmentMessage appointment)
	{
		Console.WriteLine($"Received appointment message for client: {appointment.ClientEmail}");

		try
		{
			string senderEmail = Environment.GetEnvironmentVariable("Outlook_Mail") ?? "barbershop_rs2@outlook.com";
			string senderPassword = Environment.GetEnvironmentVariable("Outlook_Password") ?? "Barbershop!";

			using var client = new SmtpClient("smtp.office365.com", 587)
			{
				EnableSsl = true,
				UseDefaultCredentials = false,
				Credentials = new NetworkCredential(senderEmail, senderPassword)
			};

			var message = new MailMessage(
				from: senderEmail,
				to: appointment.ClientEmail,
				subject: "Appointment Notification",
				body: $"We are happy to inform you that your appointment is confirmed! \n\n" +
					  $"Appointment Details:\n" +
					  $"Service: {appointment.Service}\n" +
					  $"Barber: {appointment.BarberFullName}\n" +
					  $"Date: {appointment.Date}\n" +
					  $"Time: {appointment.Time}\n\n");

			await client.SendMailAsync(message);
			Console.WriteLine("Email notification sent successfully.");
		}
		catch (SmtpException ex)
		{
			Console.WriteLine($"SMTP error sending email: {ex.Message}");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"Error sending email notification: {ex.Message}");
		}
	}
}
