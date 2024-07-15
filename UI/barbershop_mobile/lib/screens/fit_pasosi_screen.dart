// ignore_for_file: prefer_const_constructors

import 'package:barbershop_mobile/models/fit_pasos.dart';
import 'package:barbershop_mobile/models/user.dart';
import 'package:barbershop_mobile/providers/fit_pasos_provider.dart';
import 'package:barbershop_mobile/providers/user_provider.dart';
import 'package:barbershop_mobile/screens/add_fit_pasos_screen.dart';
import 'package:barbershop_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class FITPasosiScreen extends StatefulWidget {
  const FITPasosiScreen({super.key});

  @override
  createState() => _FITPasosiScreenState();
}

class _FITPasosiScreenState extends State<FITPasosiScreen> {
  late FITPasosProvider _pasosProvider;
  late UserProvider _userProvider;
  List<FITPasos> _pasosi = [];
  List<User>? _users;
  DateTime? _selectedDateFrom;
  DateTime? _selectedDateTo;
  User? _selectedUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _pasosProvider = context.read<FITPasosProvider>();
    _userProvider = context.read<UserProvider>();
    _loadPasosi();
  }

  Future<void> _loadPasosi() async {
    if (_users == null) {
      var usersData = await _userProvider.getUsers();
      setState(() {
        _users = usersData;
      });
    }

    var pasosiData = await _pasosProvider.get(filter: {
      'korisnikId': _selectedUser?.id,
      'DatumVazenjaOd': _selectedDateFrom?.toIso8601String(),
      'DatumVaznjenjaDo': _selectedDateTo?.toIso8601String()
    });

    setState(() {
      _pasosi = pasosiData;
      _isLoading = false;
    });
  }

  Widget _buildSearch() {
    return Column(
      children: [
        DropdownButtonFormField<User>(
          decoration: InputDecoration(
              labelText: 'Select user',
              border: const OutlineInputBorder(),
              suffix: IconButton(
                onPressed: () {
                  setState(() {
                    _selectedUser = null;
                  });
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              )),
          items: _users?.map((User user) {
            return DropdownMenuItem<User>(
              alignment: AlignmentDirectional.center,
              value: user,
              child: Text('${user.firstName} ${user.lastName}'),
            );
          }).toList(),
          value: _selectedUser,
          onChanged: (value) {
            setState(() {
              _selectedUser = value;
            });
          },
        ),
        Row(
          children: [
            SizedBox(width: 5),
            Expanded(
              child: TextFormField(
                readOnly: true,
                validator: FormBuilderValidators.required(
                    errorText: 'Ovo polje je obavezno'),
                controller: TextEditingController(
                    text: _selectedDateFrom == null
                        ? ''
                        : '${_selectedDateFrom!.day}.${_selectedDateFrom!.month}.${_selectedDateFrom!.year}'),
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.calendar_today),
                    labelText: 'Od datuma'),
                onTap: () async {
                  var selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));

                  if (selectedDate != null &&
                      selectedDate != _selectedDateFrom) {
                    setState(() {
                      _selectedDateFrom = selectedDate;
                    });
                  }
                },
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: TextFormField(
                readOnly: true,
                validator: FormBuilderValidators.required(
                    errorText: 'Ovo polje je obavezno'),
                controller: TextEditingController(
                    text: _selectedDateTo == null
                        ? ''
                        : '${_selectedDateTo!.day}.${_selectedDateTo!.month}.${_selectedDateTo!.year}'),
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.calendar_today),
                    labelText: 'Do datuma'),
                onTap: () async {
                  var selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));

                  if (selectedDate != null && selectedDate != _selectedDateTo) {
                    setState(() {
                      _selectedDateTo = selectedDate;
                    });
                  }
                },
              ),
            ),
            SizedBox(width: 5),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _pasosi = [];
                });
                _loadPasosi();
              },
              child: Text('Pretrazi'),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FIT Pasosi'),
        actions: [
          TextButton.icon(
            label: Text(
              'Dodaj FIT Pasos',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              _isLoading = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => AddFITPasosScreen(users: _users!)));

              if (_isLoading) {
                setState(() {
                  _isLoading = true;
                  _pasosi = [];
                });
                _loadPasosi();
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              _buildSearch(),
              SizedBox(
                width: 30,
              ),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _pasosi.isEmpty
                      ? const Center(
                          child: Text('Nema podataka o pasosima'),
                        )
                      : DataTable(
                          columns: const [
                              DataColumn(
                                label: Expanded(child: Text('Ime')),
                              ),
                              DataColumn(
                                  label: Expanded(child: Text('Prezime'))),
                              DataColumn(
                                label: Expanded(
                                    child: Text(
                                  'Datum vazenja',
                                  softWrap: true,
                                )),
                              ),
                              DataColumn(
                                label: Expanded(child: Text('Valid')),
                              ),
                            ],
                          rows: _pasosi
                              .map((e) => DataRow(cells: [
                                    DataCell(
                                      Text(
                                        e.ime.toString(),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        e.prezime.toString(),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        formatDate(e.datumVazenja)!,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        e.isValid.toString(),
                                      ),
                                    ),
                                  ]))
                              .toList()),
            ],
          )),
    );
  }
}
