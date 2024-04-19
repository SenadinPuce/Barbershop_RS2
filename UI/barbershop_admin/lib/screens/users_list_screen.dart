// ignore_for_file: use_build_context_synchronously

import 'package:barbershop_admin/providers/user_provider.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  final List<FormBuilderFieldOption<String>> _rolesOptions = [
    const FormBuilderFieldOption(value: 'Client', child: Text('Client')),
    const FormBuilderFieldOption(value: 'Barber', child: Text('Barber')),
    const FormBuilderFieldOption(value: 'Admin', child: Text('Admin')),
  ];

  Future<void> loadUsers() async {
    _userProvider = context.read<UserProvider>();

    var data = await _userProvider.getUsers(
      filter: {
        'username': _usernameController.text,
        'roleName': _selectedRole,
      },
    );

    setState(() {
      users = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearch(),
          const SizedBox(
            height: 20,
          ),
          _buildDataListView()
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: "Username",
              hintText: "Enter username",
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            ),
            controller: _usernameController,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: "Role",
              hintText: "Select role",
              alignLabelWithHint: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
        ElevatedButton(
          onPressed: () async {
            isLoading = true;
            loadUsers();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(213, 178, 99, 1),
          ),
          child: const Text("Search"),
        ),
      ],
    );
  }

  Widget _buildDataListView() {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                showCheckboxColumn: false,
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) {
                    return const Color.fromRGBO(236, 239, 241, 1);
                  },
                ),
                columns: const [
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'ID',
                        style: TextStyle(fontWeight: FontWeight.bold),
                                  softWrap:  true
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'First Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                                  softWrap:  true
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Last Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                                  softWrap:  true
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text('Username',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text('Email',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text('Phone Number',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          softWrap: true),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text('User Roles',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          softWrap: true),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Edit Roles',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        softWrap: true,
                      ),
                    ),
                  ),
                  // DataColumn(
                  //     label: Text(
                  //   'Details',
                  //   ,
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
                              color: const Color.fromRGBO(84, 181, 166, 1),
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
                    orientation: OptionsOrientation.vertical,
                    activeColor: const Color.fromRGBO(213, 178, 99, 1),
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        border: OutlineInputBorder(),
                        labelText: "Roles"),
                    name: 'roles',
                    options: _rolesOptions)),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close')),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    try {
                      if (_formKey.currentState!.saveAndValidate()) {
                        List<String>? selectedRoles =
                            _formKey.currentState?.fields['roles']?.value;

                        await _userProvider.updateUserRoles(
                            u.username, selectedRoles?.join(",") ?? "");

                        setState(() {
                          loadUsers();
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
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            },
                            textColor: Colors.white,
                          ),
                        ));
                      }
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
