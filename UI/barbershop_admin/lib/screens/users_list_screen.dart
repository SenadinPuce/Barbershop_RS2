// ignore_for_file: use_build_context_synchronously

import 'package:barbershop_admin/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../utils/util.dart';
import 'user_details_screen.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  late UserProvider _userProvider;
  List<User>? users;
  TextEditingController _usernameController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    _userProvider = context.read<UserProvider>();

    var data = await _userProvider.getUsers(
      filter: {
        'username': _usernameController.text,
        'roleName': 'Barber',
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
        const SizedBox(
          width: 8,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(84, 181, 166, 1),
          ),
          onPressed: () async {
            isLoading = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => UserDetailsScreen()));
            if (isLoading) {
              setState(() {});
              loadUsers();
            }
          },
          child: const Text("Add new barber"),
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
                dataRowMaxHeight: 70,
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) {
                    return const Color.fromRGBO(236, 239, 241, 1);
                  },
                ),
                columns: const [
                  DataColumn(
                    label: Expanded(
                      child: Text('ID',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          softWrap: true),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text('First Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          softWrap: true),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text('Last Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          softWrap: true),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Photo',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Email',
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
                      child: Text(
                        'Edit',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        softWrap: true,
                      ),
                    ),
                  ),
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      'Delete',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  )),
                ],
                rows: (users ?? [])
                    .map(
                      (User u) => DataRow(
                        cells: [
                          DataCell(Text(u.id.toString())),
                          DataCell(Text(u.firstName.toString())),
                          DataCell(Text(u.lastName.toString())),
                          DataCell(u.photo != ""
                              ? Container(
                                  width: 70,
                                  height: 70,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 0),
                                  child: imageFromBase64String(u.photo!),
                                )
                              : const Text("")),
                          DataCell(Text(u.email.toString())),
                          DataCell(Text(u.phoneNumber.toString())),
                          DataCell(IconButton(
                              icon: const Icon(Icons.edit_document),
                              color: const Color.fromRGBO(84, 181, 166, 1),
                              onPressed: () async {
                                isLoading = await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => UserDetailsScreen(
                                              user: u,
                                            )));
                                if (isLoading) {
                                  setState(() {
                                    loadUsers();
                                  });
                                }
                              })),
                          DataCell(IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Color(0xfff71133),
                            ),
                            onPressed: () {
                              _deleteUser(u);
                            },
                          ))
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          );
  }

  void _deleteUser(User u) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete'),
            content: const Text(
                'Are you sure you want to delete this barber? This action is not reversible.'),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("No")),
              ElevatedButton(
                child: const Text("Yes"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  try {
                    await _userProvider.delete(u.id!);

                    setState(() {
                      users?.removeWhere((element) => element.id == u.id);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.0),
                          Text("User deleted successfully.")
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
                              'Failed to delete user. Please try again.',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.red,
                        action: SnackBarAction(
                          label: 'Dismiss',
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                          textColor: Colors.white,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        });
  }
}
