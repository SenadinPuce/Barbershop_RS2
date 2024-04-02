import 'dart:convert';
import 'package:barbershop_mobile/models/delivery_method.dart';
import 'package:barbershop_mobile/models/order.dart';
import 'package:barbershop_mobile/providers/account_provider.dart';
import 'package:barbershop_mobile/providers/cart_provider.dart';
import 'package:barbershop_mobile/providers/delivery_method_provider.dart';
import 'package:barbershop_mobile/providers/order_provider.dart';
import 'package:barbershop_mobile/screens/payment_success.dart';
import 'package:barbershop_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/address.dart' as BarbershopAddress;
import '../utils/constants.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late DeliveryMethodProvider _deliveryMethodProvider;
  late AccountProvider _accountProvider;
  late CartProvider _cartProvider;
  late OrderProvider _orderProvider;
  List<DeliveryMethod>? _deliveryMethods;
  BarbershopAddress.Address? _address;
  final _formKey = GlobalKey<FormBuilderState>();
  DeliveryMethod? _selectedDeliveryMethod;
  Map<String, dynamic>? paymentIntent;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartProvider = context.read<CartProvider>();
  }

  Future loadData() async {
    _deliveryMethodProvider = context.read<DeliveryMethodProvider>();
    _accountProvider = context.read<AccountProvider>();
    _orderProvider = context.read<OrderProvider>();

    var deliveryMethodsData = await _deliveryMethodProvider.get();
    var addressData = await _accountProvider.getAddress();

    setState(() {
      _deliveryMethods = deliveryMethodsData;
      _address = addressData;
      isLoading = false;
    });
  }

  stripeMakePayment() async {
    try {
      paymentIntent = await createPaymentIntent(
          (calculateAmount() * 100).round().toString(), 'USD');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Barbershop'))
          .then((value) {});

      displayPaymentSheet();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      await insertOrder();

      print('Payment succesfully completed');
    } on Exception catch (e) {
      if (e is StripeException) {
        print('Error from Stripe: ${e.error.localizedMessage}');
      } else {
        print('Unforeseen error: ${e}');
      }
    }
  }

  insertOrder() async {
    List<Map> orderItems = [];
    _cartProvider.cart.items.forEach((element) {
      orderItems.add({'Id': element.product.id, 'Quantity': element.count});
    });

    final formData = _formKey.currentState!.value;
    final String firstName = formData['firstName'];
    final String lastName = formData['lastName'];
    final String street = formData['street'];
    final String city = formData['city'];
    final String state = formData['state'];
    final String zipCode = formData['zipCode'];

    final address = BarbershopAddress.Address(
      firstName: firstName,
      lastName: lastName,
      street: street,
      city: city,
      state: state,
      zipCode: zipCode,
    );

    Map order = {
      'ClientId': Authorization.id,
      'PaymentIntentId': paymentIntent?['id'],
      'DeliveryMethodId': _selectedDeliveryMethod?.id,
      'Address': address,
      'Items': orderItems
    };

    await _orderProvider.insert(request: order);

    setState(() {
      paymentIntent = null;
      _selectedDeliveryMethod = null;
      _cartProvider.cart.items.clear();
    });

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const PaymentSuccessScreen()));
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (e) {
      print('Exception: $e');
    }
  }

  double calculateAmount() {
    double cartTotal = _selectedDeliveryMethod!.price!;
    for (var element in _cartProvider.cart.items) {
      cartTotal += (element.product.price! * element.count).toDouble();
    }

    return cartTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Back to Cart", style: GoogleFonts.tiltNeon(fontSize: 25)),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(child: _buildView()),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildCheckoutButton(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildView() {
    if (isLoading) {
      return Container();
    } else {
      return FormBuilder(
        key: _formKey,
        initialValue: {
          'firstName': _address!.firstName ?? '',
          'lastName': _address!.lastName ?? '',
          'street': _address!.street ?? '',
          'city': _address!.city ?? '',
          'state': _address!.state ?? '',
          'zipCode': _address!.zipCode ?? '',
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choose Delivery Method:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FormBuilderRadioGroup<DeliveryMethod>(
                      name: 'deliveryMethod',
                      onChanged: (selectedMethod) {
                        setState(() {
                          _selectedDeliveryMethod = selectedMethod;
                        });
                      },
                      validator: FormBuilderValidators.required(
                          errorText: "You need to choose delivery method."),
                      options: _deliveryMethods!
                          .map((method) => FormBuilderFieldOption(
                                value: method,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _selectedDeliveryMethod == method
                                          ? Colors.blue.withOpacity(0.1)
                                          : null,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            method.shortName ?? '',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 5),
                                          if (method.deliveryTime != null)
                                            Text(
                                              'Delivery Time: ${method.deliveryTime}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          if (method.price != null)
                                            Text(
                                              'Price: \$${method.price}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Delivery Address:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    FormBuilderTextField(
                      name: 'firstName',
                      decoration:
                          const InputDecoration(labelText: 'First Name'),
                      validator: FormBuilderValidators.required(),
                    ),
                    FormBuilderTextField(
                      name: 'lastName',
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      validator: FormBuilderValidators.required(),
                    ),
                    FormBuilderTextField(
                      name: 'street',
                      decoration: const InputDecoration(labelText: 'Street'),
                      validator: FormBuilderValidators.required(),
                    ),
                    FormBuilderTextField(
                      name: 'city',
                      decoration: const InputDecoration(labelText: 'City'),
                      validator: FormBuilderValidators.required(),
                    ),
                    FormBuilderTextField(
                      name: 'state',
                      decoration: const InputDecoration(labelText: 'State'),
                      validator: FormBuilderValidators.required(),
                    ),
                    FormBuilderTextField(
                      name: 'zipCode',
                      decoration: const InputDecoration(labelText: 'Zip Code'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric()
                      ]),
                    ),
                  ],
                )),
            const SizedBox(
              height: 80,
            )
          ],
        ),
      );
    }
  }

  Widget _buildCheckoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              minimumSize: const Size(double.infinity, 45),
              elevation: 3),
          onPressed: () async {
            if (_formKey.currentState!.saveAndValidate()) {
              await stripeMakePayment();
            }
          },
          child: const Text(
            'Checkout',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
