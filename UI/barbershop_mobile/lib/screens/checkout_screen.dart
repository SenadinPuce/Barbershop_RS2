// ignore_for_file: use_build_context_synchronously

import 'package:barbershop_mobile/models/delivery_method.dart';
import 'package:barbershop_mobile/providers/account_provider.dart';
import 'package:barbershop_mobile/providers/cart_provider.dart';
import 'package:barbershop_mobile/providers/delivery_method_provider.dart';
import 'package:barbershop_mobile/providers/order_provider.dart';
import 'package:barbershop_mobile/providers/payment_provider.dart';
import 'package:barbershop_mobile/screens/payment_success.dart';
import 'package:barbershop_mobile/utils/util.dart';
import 'package:barbershop_mobile/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../models/address.dart' as BarbershopAddress;
import '../widgets/order_summary.dart';

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
  late PaymentProvider _paymentProvider;
  List<DeliveryMethod>? _deliveryMethods;
  BarbershopAddress.Address? _address;
  final _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = true;
  bool isSheetLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartProvider = context.watch<CartProvider>();
  }

  Future loadData() async {
    _deliveryMethodProvider = context.read<DeliveryMethodProvider>();
    _accountProvider = context.read<AccountProvider>();
    _orderProvider = context.read<OrderProvider>();
    _paymentProvider = context.read<PaymentProvider>();

    var deliveryMethodsData = await _deliveryMethodProvider.get();
    var addressData = await _accountProvider.getAddress();

    setState(() {
      _deliveryMethods = deliveryMethodsData;
      _address = addressData;
      isLoading = false;
    });
  }

  Map<String, dynamic> _buildAddressFromFormData(
      Map<String, dynamic> formData) {
    return {
      'firstName': formData['firstName'],
      'lastName': formData['lastName'],
      'street': formData['street'],
      'city': formData['city'],
      'state': formData['state'],
      'zipCode': formData['zipCode'],
    };
  }

  List<Map<String, dynamic>> _buildOrderItems() {
    return _cartProvider.cart.items.map((element) {
      return {'Id': element.product.id, 'Quantity': element.count};
    }).toList();
  }

  stripeMakePayment() async {
    setState(() {
      isSheetLoading = true;
    });

    try {
      final formData = _formKey.currentState!.value;
      final address = _buildAddressFromFormData(formData);

      Map request = {
        'PaymentIntentId': _cartProvider.customerPayment?.paymentIntentId,
        'DeliveryMethodId': _cartProvider.selectedDeliveryMethod?.id,
        'Address': address,
        'Items': _buildOrderItems()
      };

      _cartProvider.customerPayment =
          await _paymentProvider.insert(request: request);

      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      _cartProvider.customerPayment?.clientSecret,
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
      await insertOrder();

      setState(() {
        isSheetLoading = false;
      });

      await Stripe.instance.presentPaymentSheet();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const PaymentSuccessScreen(),
          ),
          (route) => route.isFirst);

      print('Payment sheet presented successfully');
      print('Payment successfully completed');
    } on Exception catch (e) {
      if (e is StripeException) {
        print('Error from Stripe: ${e.error.localizedMessage}');
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Error from stripe'),
                  content: const Text(
                      'An unknown error occurred. Please try again later.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Ok"))
                  ],
                ));
      } else {
        print('Unforeseen error: ${e}');
      }
    }
  }

  insertOrder() async {
    final formData = _formKey.currentState!.value;
    final address = _buildAddressFromFormData(formData);

    Map order = {
      'ClientId': Authorization.id,
      'PaymentIntentId': _cartProvider.customerPayment?.paymentIntentId,
      'DeliveryMethodId': _cartProvider.selectedDeliveryMethod?.id,
      'Address': address,
      'Items': _buildOrderItems()
    };

    await _orderProvider.insert(request: order);

    setState(() {
      _cartProvider.customerPayment = null;
      _cartProvider.selectedDeliveryMethod = null;
      _cartProvider.cart.items.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Checkout'),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (isLoading == false) _buildView(),
                    const SizedBox(
                      height: 10,
                    ),
                    if (isLoading == false)
                      OrderSummaryWidget(cartProvider: _cartProvider),
                    const SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            ),
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
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: FormBuilder(
        key: _formKey,
        initialValue: {
          'deliveryMethodId':
              _cartProvider.selectedDeliveryMethod?.id.toString(),
          'firstName': _address?.firstName ?? '',
          'lastName': _address?.lastName ?? '',
          'street': _address?.street ?? '',
          'city': _address?.city ?? '',
          'state': _address?.state ?? '',
          'zipCode': _address?.zipCode ?? '',
        },
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose Delivery Method:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FormBuilderRadioGroup<String>(
                  name: 'deliveryMethodId',
                  onChanged: (selectedMethodId) {
                    int id = int.parse(selectedMethodId!);
                    DeliveryMethod? selectedMethod =
                        _deliveryMethods?.firstWhereOrNull(
                      (method) => method.id == id,
                    );
                    _cartProvider.setSelectedDeliveryMethod(selectedMethod!);
                  },
                  validator: FormBuilderValidators.required(
                    errorText: "You need to choose a delivery method.",
                  ),
                  options: _deliveryMethods!
                      .map((method) => FormBuilderFieldOption(
                            value: method.id.toString(),
                            child: SizedBox(
                              width: double.infinity,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _cartProvider
                                              .selectedDeliveryMethod?.id ==
                                          method.id
                                      ? Colors.blue.withOpacity(0.1)
                                      : null,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 20.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        method.shortName ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
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
                  decoration: const InputDecoration(labelText: 'First Name'),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(84, 181, 166, 1),
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
          child: isSheetLoading
              ? const CircularProgressIndicator()
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Make a Payment',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.payment)
                  ],
                ),
        ),
      ),
    );
  }
}
