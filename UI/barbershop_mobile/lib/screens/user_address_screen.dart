import 'package:barbershop_mobile/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/address.dart';
import '../providers/account_provider.dart';

class UserAddressScreen extends StatefulWidget {
  const UserAddressScreen({super.key});

  @override
  State<UserAddressScreen> createState() => _UserAddressScreenState();
}

class _UserAddressScreenState extends State<UserAddressScreen> {
  late AccountProvider _accountProvider;
  final _formKey = GlobalKey<FormBuilderState>();
  Address? _address;
  bool isLoading = true;
  bool isFormEdited = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    _accountProvider = context.read<AccountProvider>();

    var addressData = await _accountProvider.getAddress();

    setState(() {
      _address = addressData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Delivery address'),
      body: SafeArea(
          child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(children: [if (_address != null) _buildView()]),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
        ],
      )),
    );
  }

  Widget _buildView() {
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
        onChanged: () {
          setState(() {
            isFormEdited = true;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormBuilderTextField(
              name: 'firstName',
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(
              height: 5,
            ),
            FormBuilderTextField(
              name: 'lastName',
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(
              height: 5,
            ),
            FormBuilderTextField(
              name: 'street',
              decoration: const InputDecoration(labelText: 'Street'),
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(
              height: 5,
            ),
            FormBuilderTextField(
              name: 'city',
              decoration: const InputDecoration(labelText: 'City'),
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(
              height: 5,
            ),
            FormBuilderTextField(
              name: 'state',
              decoration: const InputDecoration(labelText: 'State'),
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(
              height: 5,
            ),
            FormBuilderTextField(
              name: 'zipCode',
              decoration: const InputDecoration(labelText: 'Zip Code'),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.numeric()
              ]),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _buildSubmitButton()
          ],
        ));
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 45),
          backgroundColor: const Color.fromRGBO(84, 181, 166, 1),
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        ),
        onPressed: isFormEdited
            ? () async {
                if (_formKey.currentState?.saveAndValidate() == true) {
                  var request = Map.from(_formKey.currentState!.value);

                  await _accountProvider.updateAddress(request);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Colors.green,
                        showCloseIcon: true,
                        closeIconColor: Colors.white,
                        duration: Duration(seconds: 1),
                        content: Text('Delivery address updated successfully')),
                  );
                }
              }
            : null,
        child: const Text(
          'Save changes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
