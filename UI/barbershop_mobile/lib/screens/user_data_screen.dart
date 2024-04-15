import 'package:barbershop_mobile/models/user.dart';
import 'package:barbershop_mobile/providers/user_provider.dart';
import 'package:barbershop_mobile/utils/util.dart';
import 'package:barbershop_mobile/widgets/back_button_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  late UserProvider _userProvider;
  final _formKey = GlobalKey<FormBuilderState>();
  User? _user;
  bool isLoading = true;
  bool isFormEdited = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    _userProvider = context.read<UserProvider>();

    var userData = await _userProvider.getById(Authorization.id!);

    setState(() {
      _user = userData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackButtonAppBar(),
      body: SafeArea(
          child: Stack(children: [
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [if (_user != null) _buildView()],
            ),
          ),
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ])),
    );
  }

  Widget _buildView() {
    return FormBuilder(
      key: _formKey,
      initialValue: {
        'firstName': _user!.firstName ?? '',
        'lastName': _user!.lastName ?? '',
        'username': _user!.username ?? '',
        'email': _user!.email ?? '',
        'phoneNumber': _user!.phoneNumber ?? '',
      },
      onChanged: () {
        setState(() {
          isFormEdited = true;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Personal Data',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
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
            name: 'username',
            decoration: const InputDecoration(labelText: 'Username'),
            validator: FormBuilderValidators.required(),
          ),
          const SizedBox(
            height: 5,
          ),
          FormBuilderTextField(
            name: 'email',
            decoration: const InputDecoration(labelText: 'Email'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.email()
            ]),
          ),
          const SizedBox(
            height: 5,
          ),
          FormBuilderTextField(
            name: 'phoneNumber',
            decoration:
                const InputDecoration(labelText: 'Phone Number (optional)'),
          ),
          const SizedBox(height: 20),
          _buildSubmitButton()
        ],
      ),
    );
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

                  await _userProvider.update(Authorization.id!,
                      request: request);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Colors.green,
                        showCloseIcon: true,
                        closeIconColor: Colors.white,
                        duration: Duration(seconds: 1),
                        content: Text('Personal data updated successfully')),
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
