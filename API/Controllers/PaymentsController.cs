using API.Errors;
using Core.Entities.OrderAggregate;
using Core.Interfaces;
using Core.Models.UpsertObjects;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Stripe;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PaymentsController : ControllerBase
    {
        private readonly string _whSecret;
        private readonly IPaymentService _paymentService;
        private readonly ILogger<PaymentsController> _logger;
        public PaymentsController(IPaymentService paymentService, ILogger<PaymentsController> logger, IConfiguration config)
        {
            _logger = logger;
            _paymentService = paymentService;
            _whSecret = config.GetSection("StripeSettings:WhSecret").Value;
        }

        [Authorize]
        [HttpPost]
        public async Task<ActionResult<CustomerPaymentDto>> CreateOrUpdatePaymentIntent([FromBody] PaymentUpsertObject upsert)
        {
            var customerPaymentDto = await _paymentService.CreateOrUpdatePaymentIntent(upsert);

            if (customerPaymentDto == null) return BadRequest(new ApiResponse(400, "Problem with creating payment intent"));

            return Ok(customerPaymentDto);
        }

        [HttpPost("webhook")]
        public async Task<ActionResult> StripeWebhook()
        {
            var json = await new StreamReader(HttpContext.Request.Body).ReadToEndAsync();

            var stripeEvent = EventUtility.ConstructEvent(json, Request.Headers["Stripe-Signature"], _whSecret, throwOnApiVersionMismatch: false);

            PaymentIntent intent;
            Order order;

            switch (stripeEvent.Type)
            {
                case "payment_intent.succeeded":
                    intent = (PaymentIntent)stripeEvent.Data.Object;
                    _logger.LogInformation($"Payment succeeded: {intent.Id}");
                    order = await _paymentService.UpdateOrderPaymentSucceeded(intent.Id);
                    _logger.LogInformation($"Order updated to payment received: {order.Id}");
                    break;
                case "payment_intent.payment_failed":
                    intent = (PaymentIntent)stripeEvent.Data.Object;
                    _logger.LogInformation($"Payment failed: {intent.Id}");
                    order = await _paymentService.UpdateOrderPaymentFailed(intent.Id);
                    _logger.LogInformation($"Order updated to payment failed: {order.Id}");
                    break;
            }

            return new EmptyResult();
        }
    }
}