// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously

import 'package:barbershop_admin/providers/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../widgets/master_screen.dart';

class UserDetailScreen extends StatefulWidget {
  User? user;

  UserDetailScreen({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  List<String> availableRoles = ['Client', 'Barber', 'Admin'];
  late UserProvider _adminProvider;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      "firstName": widget.user?.firstName,
      "lastName": widget.user?.lastName,
      "username": widget.user?.username,
      "email": widget.user?.email,
      "phoneNumber": widget.user?.phoneNumber,
      "pictureUrl": widget.user?.pictureUrl,
      "roles": widget.user?.roles
    };

    _adminProvider = context.read<UserProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "User details",
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              _buildForm(),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                      width: 150,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: shouldDisableButton()
                            ? null
                            : () async {
                                try {
                                  List<String>? selectedRoles = _formKey
                                      .currentState
                                      ?.fields['roles']
                                      ?.value as List<String>?;

                                  widget.user =
                                      await _adminProvider.updateUserRoles(
                                          widget.user?.username,
                                          {
                                                "roles":
                                                    selectedRoles?.join(",")
                                              }["roles"] ??
                                              "");

                                  setState(() {
                                    _initialValue['roles'] = widget.user?.roles;
                                  });

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        "User roles updated successfully."),
                                    backgroundColor: Colors.green,
                                  ));
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Failed to update user roles. Please try again.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                        child: const Text("Save changes"),
                      ))
                ],
              )
            ],
          ),
        ));
  }

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            _buildUserPicture(),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: FormBuilderTextField(
                decoration: const InputDecoration(
                  labelText: 'First name',
                  labelStyle: TextStyle(color: Colors.blue),
                ),
                name: "firstName",
                enabled: false,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: FormBuilderTextField(
                decoration: const InputDecoration(
                  labelText: 'Last name',
                  labelStyle: TextStyle(color: Colors.blue),
                ),
                name: "lastName",
                enabled: false,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: FormBuilderTextField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.blue),
                ),
                name: "username",
                enabled: false,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        const Text(
          "Contact",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              child: FormBuilderTextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.blue),
                ),
                name: "email",
                enabled: false,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: FormBuilderTextField(
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  labelStyle: TextStyle(color: Colors.blue),
                ),
                name: "phoneNumber",
                enabled: false,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        const Text(
          "Edit user roles",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderCheckboxGroup(
          name: 'roles',
          initialValue: _initialValue['roles'] as List<String>?,
          wrapAlignment: WrapAlignment.start,
          wrapSpacing: 10,
          onChanged: (List<String>? selectedRoles) {
            setState(() {});
          },
          options: const [
            FormBuilderFieldOption(
              value: 'Client',
              child: Text('Client'),
            ),
            FormBuilderFieldOption(
              value: 'Barber',
              child: Text('Barber'),
            ),
            FormBuilderFieldOption(
              value: 'Admin',
              child: Text('Admin'),
            ),
          ],
        )
      ]),
    );
  }

  Widget _buildUserPicture() {
    final String? pictureUrl = _initialValue["pictureUrl"];

    return pictureUrl != null
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 205, 205, 205),
                width: 1,
              ),
            ),
            child: Image.network(
              pictureUrl,
              width: 140,
              height: 140,
              fit: BoxFit.cover,
            ),
          )
        : Container();
  }

  bool shouldDisableButton() {
    List<String>? selectedRoles =
        _formKey.currentState?.fields['roles']?.value as List<String>?;

    List<String>? userRoles = _initialValue['roles'] as List<String>?;

    return selectedRoles == null ||
        selectedRoles.isEmpty ||
        listEquals(selectedRoles, userRoles);
  }
}
