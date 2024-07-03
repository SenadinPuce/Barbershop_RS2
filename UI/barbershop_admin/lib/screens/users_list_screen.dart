import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/util.dart';
import 'user_details_screen.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  late UserProvider _userProvider;
  List<User>? _users;
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    _userProvider = context.read<UserProvider>();

    var usersData = await _userProvider.getUsers(
      filter: {
        'FTS': _nameController.text,
      },
    );

    setState(() {
      _users = usersData;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
              labelText: "First name and/or last name",
              hintText: "Search for barber",
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            ),
            controller: _nameController,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });
            _loadUsers();
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
            _isLoading = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const UserDetailsScreen()));
            if (_isLoading) {
              setState(() {});
              _loadUsers();

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.0),
                    Text("User saved successfully.")
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
            }
          },
          child: const Text("Add user"),
        ),
      ],
    );
  }

  Widget _buildDataListView() {
    return _isLoading
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
                        'Roles',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        softWrap: true,
                      ),
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
                      child: Text(
                        'Phone number',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                rows: (_users ?? [])
                    .map(
                      (User u) => DataRow(
                        cells: [
                          DataCell(Text(u.firstName.toString())),
                          DataCell(Text(u.lastName.toString())),
                          DataCell(
                              Text(u.roles!.map((role) => role).join(', '))),
                          DataCell(
                            Container(
                              width: 70,
                              height: 70,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: u.photo != null
                                    ? imageFromBase64String(u.photo!)
                                    : Image.asset(
                                        'assets/images/profile.png',
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            ),
                          ),
                          DataCell(Text(u.email.toString())),
                          DataCell(Text(u.phoneNumber.toString())),
                          DataCell(IconButton(
                              icon: const Icon(Icons.edit_document),
                              color: const Color.fromRGBO(84, 181, 166, 1),
                              onPressed: () async {
                                _isLoading = await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => UserDetailsScreen(
                                              user: u,
                                            )));
                                if (_isLoading) {
                                  setState(() {});
                                  _loadUsers();

                                  if (!context.mounted) return;

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: const Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8.0),
                                        Text("User saved successfully.")
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
                      _users?.removeWhere((element) => element.id == u.id);
                    });

                    if (!context.mounted) return;

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
