using System.Net;
using System.Net.Mail;
using EasyNetQ;
using Core;

class Program
{
    private static CancellationTokenSource _cancellationTokenSource;

    static async Task Main(string[] args)
    {
        _cancellationTokenSource = new CancellationTokenSource();

        string hostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost";
        string username = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
        string password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";

        var connectionString = $"host={hostName};username={username};password={password}";

        using var bus = RabbitHutch.CreateBus(connectionString);
        bus.PubSub.Subscribe<AppointmentMessage>("mail_service", SendEmailNotificationAsync);


        Console.WriteLine("Listening for messages. Press CTRL+C to exit.");

        Console.CancelKeyPress += (sender, e) =>
        {
            e.Cancel = true;
            _cancellationTokenSource.Cancel();
        };


        await WaitForCancellationAsync();
    }

    static async Task WaitForCancellationAsync()
    {
        try
        {
            await Task.Delay(Timeout.Infinite, _cancellationTokenSource.Token);
        }
        catch (OperationCanceledException)
        {
            Console.WriteLine("Application is shutting down...");
        }
    }

    static async Task SendEmailNotificationAsync(AppointmentMessage appointment)
    {
        Console.WriteLine("Message received");

        try
        {
            string senderEmail = Environment.GetEnvironmentVariable("OUTLOOK_MAIL") ?? "barbershop_rs2@outlook.com";
            string senderPassword = Environment.GetEnvironmentVariable("OUTLOOK_PASS") ?? "Barbershop!";

            using var client = new SmtpClient("smtp.office365.com", 587);
            client.EnableSsl = true;
            client.UseDefaultCredentials = false;
            client.Credentials = new NetworkCredential(senderEmail, senderPassword);

            var message = new MailMessage(
                from: senderEmail,
                to: appointment.ClientEmail,
                subject: "Appointment Notification",
                body: $"We are happy to inform you that your appointment is confirmed! \n\n" +
                      $"Appointment Details:\n" +
                      $"Service: {appointment.Service}\n" +
                      $"Barber: {appointment.BarberFullName}\n" +
                      $"Date and Time: {appointment.DateTime}");

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
        finally
        {
            Console.WriteLine("Listening for messages. Press CTRL+C to exit.");
        }
    }
}
