// ignore_for_file: use_build_context_synchronously

import 'package:barbershop_admin/providers/user_provider.dart';
import 'package:barbershop_admin/screens/user_detail_screen.dart';
import 'package:barbershop_admin/widgets/master_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  late UserProvider _userProvider;
  List<User>? users;
  TextEditingController _usernameController = TextEditingController();
  String? _selectedRole;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  List<String> availableRoles = ['Client', 'Barber', 'Admin'];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    _userProvider = context.read<UserProvider>();

    var data = await _userProvider.getUsers(
      filter: {
        'username': _usernameController.text,
        'roleName': _selectedRole,
      },
    );

    setState(() {
      isLoading = false;
      users = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Users",
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSearch(),
                  const SizedBox(
                    height: 8,
                  ),
                  _buildDataListView()
                ],
              ),
      ),
    );
  }

  Widget _buildSearch() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: "Username",
              contentPadding: EdgeInsets.all(0),
            ),
            controller: _usernameController,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: "Role",
              contentPadding: const EdgeInsets.all(0),
              suffix: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _selectedRole = null;
                  });
                },
              ),
            ),
            value: _selectedRole,
            items: ['Client', 'Barber', 'Admin']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                alignment: AlignmentDirectional.center,
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedRole = newValue;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 150,
          height: 40,
          child: ElevatedButton(
            onPressed: () async {
              isLoading = true;
              _loadUsers();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text("Search"),
          ),
        ),
      ],
    );
  }

  Widget _buildDataListView() {
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          showCheckboxColumn: false,
          columns: const [
            DataColumn(
              label: Text('ID', style: TextStyle(fontStyle: FontStyle.italic)),
            ),
            DataColumn(
              label: Text('First Name',
                  style: TextStyle(fontStyle: FontStyle.italic)),
            ),
            DataColumn(
              label: Text('Last Name',
                  style: TextStyle(fontStyle: FontStyle.italic)),
            ),
            DataColumn(
              label: Text('Username',
                  style: TextStyle(fontStyle: FontStyle.italic)),
            ),
            DataColumn(
              label:
                  Text('Email', style: TextStyle(fontStyle: FontStyle.italic)),
            ),
            DataColumn(
              label: Text('Phone Number',
                  style: TextStyle(fontStyle: FontStyle.italic)),
            ),
            DataColumn(
              label: Text('User Roles',
                  style: TextStyle(fontStyle: FontStyle.italic)),
            ),
            DataColumn(
              label: Text('Edit Roles',
                  style: TextStyle(fontStyle: FontStyle.italic)),
            ),
            // DataColumn(
            //     label: Text(
            //   'Details',
            //   style: TextStyle(fontStyle: FontStyle.italic),
            // ))
          ],
          rows: (users ?? [])
              .map(
                (User u) => DataRow(
                  cells: [
                    DataCell(Text(u.id.toString())),
                    DataCell(Text(u.firstName.toString())),
                    DataCell(Text(u.lastName.toString())),
                    DataCell(Text(u.username.toString())),
                    DataCell(Text(u.email.toString())),
                    DataCell(Text(u.phoneNumber.toString())),
                    DataCell(Text(u.roles?.join(', ') ?? '')),
                    DataCell(IconButton(
                        icon: const Icon(Icons.edit_document),
                        color: Colors.green,
                        onPressed: () {
                          _editRoles(u);
                        })),
                    // DataCell(IconButton(
                    //     icon: const Icon(Icons.info),
                    //     color: Colors.blue,
                    //     onPressed: () {
                    //       Navigator.of(context).push(MaterialPageRoute(
                    //           builder: (context) => UserDetailScreen(
                    //                 user: u,
                    //               )));
                    //     }))
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _editRoles(User u) {
    _initialValue = {'roles': u.roles};

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit roles'),
            content: FormBuilder(
                key: _formKey,
                initialValue: _initialValue,
                child: FormBuilderCheckboxGroup(
                  name: 'roles',
                  initialValue: _initialValue['roles'] as List<String>?,
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
                )),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close')),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    try {
                      List<String>? selectedRoles = _formKey.currentState
                          ?.fields['roles']?.value as List<String>?;

                      await _userProvider.updateUserRoles(u.username,
                          {"roles": selectedRoles?.join(",")}["roles"] ?? "");

                      setState(() {
                        _loadUsers();
                      });

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8.0),
                            Text("User roles saved successfully.")
                          ],
                        ),
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.green,
                        action: SnackBarAction(
                          label: 'Dismiss',
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                          textColor: Colors.white,
                        ),
                      ));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(
                                Icons.error,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Failed to update user roles. Please try again.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.red,
                          action: SnackBarAction(
                            label: 'Dismiss',
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            },
                            textColor: Colors.white,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text("Save changes"))
            ],
          );
        });
  }
}
