import 'package:barbershop_admin/providers/admin_provider.dart';
import 'package:barbershop_admin/screens/user_detail_screen.dart';
import 'package:barbershop_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  late AdminProvider _adminProvider;
  List<User>? users;
  TextEditingController _usernameController = TextEditingController();
  String? _selectedRole = 'All';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    _adminProvider = context.read<AdminProvider>();

    String roleNameToSend = (_selectedRole == 'All') ? '' : _selectedRole!;
    var data = await _adminProvider.getUsers(
      filter: {
        'username': _usernameController.text,
        'roleName': roleNameToSend,
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
        child: Column(
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
            value: _selectedRole,
            items: ['All', 'Client', 'Barber', 'Admin']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedRole = newValue ?? '';
              });
            },
            decoration: const InputDecoration(
              labelText: "Role",
              contentPadding: EdgeInsets.all(0),
            ),
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
            child: Text("Search"),
          ),
        ),
      ],
    );
  }

  Widget _buildDataListView() {
    return Expanded(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: DataTable(
                showCheckboxColumn: false,
                columns: const [
                  DataColumn(
                    label: Text('ID',
                        style: TextStyle(fontStyle: FontStyle.italic)),
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
                    label: Text('Email',
                        style: TextStyle(fontStyle: FontStyle.italic)),
                  ),
                  DataColumn(
                    label: Text('Phone Number',
                        style: TextStyle(fontStyle: FontStyle.italic)),
                  ),
                  DataColumn(
                    label: Text('User Roles',
                        style: TextStyle(fontStyle: FontStyle.italic)),
                  ),
                ],
                rows: (users ?? [])
                    .map(
                      (User u) => DataRow(
                        onSelectChanged: (selected) {
                          if (selected == true) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => UserDetailScreen(
                                  user: u,
                                ),
                              ),
                            );
                          }
                        },
                        cells: [
                          DataCell(Text(u.id.toString())),
                          DataCell(Text(u.firstName.toString())),
                          DataCell(Text(u.lastName.toString())),
                          DataCell(Text(u.username.toString())),
                          DataCell(Text(u.email.toString())),
                          DataCell(Text(u.phoneNumber.toString())),
                          DataCell(Text(u.roles?.join(', ') ?? '')),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }
}
