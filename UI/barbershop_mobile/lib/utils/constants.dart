const apiUrl = String.fromEnvironment("baseUrl",
    defaultValue: "http://10.0.2.2:5001/api/");

const stripePublishKey = String.fromEnvironment('stripePublishKey',
    defaultValue:
        'pk_test_51MZBO5Ek5EtK65QTOqrIoYAQpPQxSK4InviG0378e4B7MpyFzRg1hjO9UGov8L0AMo2ktXVnaLmmgkZd37Tpuxo000lzGx3h6S');
const stripeSecretKey = String.fromEnvironment('stripeSecretKey',
    defaultValue:
        'sk_test_51MZBO5Ek5EtK65QTeYZBbi7YxNfC2V6uinRS0vked0udfI3GFUk4Re1a1uwdjaK4XRZ7uknxVQZEWAqCgahQQ9JN00v6Bj1QRi');
const appTitle = 'Barbershop';
