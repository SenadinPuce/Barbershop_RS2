import 'package:barbershop_admin/screens/term_details_screen.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/term.dart';
import '../models/user.dart';
import '../providers/term_provider.dart';
import '../providers/user_provider.dart';
import '../utils/util.dart';

class TermsListScreen extends StatefulWidget {
  const TermsListScreen({super.key});

  @override
  State<TermsListScreen> createState() => _TermsListScreenState();
}

class _TermsListScreenState extends State<TermsListScreen> {
  late TermProvider _termProvider;
  late UserProvider _userProvider;
  List<Term>? _terms;
  List<User>? _barbers;
  DateTime? _selectedDate;
  User? _selectedBarber;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTerms();
  }

  Future<void> _loadTerms() async {
    _termProvider = context.read<TermProvider>();
    _userProvider = context.read<UserProvider>();

    if (_barbers == null) {
      var barbers =
          await _userProvider.getUsers(filter: {'roleName': 'barber'});
      _barbers = List.from(barbers);
    }

    var termData = await _termProvider.get(filter: {
      'barberId': _selectedBarber?.id,
      'date': _selectedDate,
    });

    setState(() {
      _terms = termData;
      _isLoading = false;
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
          const SizedBox(height: 20),
          _buildDataListView(),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
            child: DateTimeField(
          decoration: const InputDecoration(
            labelText: 'Select date',
            hintText: 'Select date',
            floatingLabelStyle:
                TextStyle(color: Color.fromRGBO(213, 178, 99, 1)),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            suffixIcon: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Icon(Icons.calendar_today,
                  color: Color.fromRGBO(213, 178, 99, 1)),
            ),
          ),
          selectedDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          dateFormat: DateFormat('dd MMM yyyy'),
          mode: DateTimeFieldPickerMode.date,
          onDateSelected: (value) {
            setState(() {
              _selectedDate = value;
            });
          },
        )),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: DropdownButtonFormField<User>(
          decoration: InputDecoration(
            labelText: "Barber",
            hintText: 'Select barber',
            alignLabelWithHint: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            suffix: IconButton(
                onPressed: () => {
                      setState(() {
                        _selectedBarber = null;
                      })
                    },
                icon: const Icon(Icons.close)),
          ),
          value: _selectedBarber,
          items: _barbers
              ?.map<DropdownMenuItem<User>>(
                  (User user) => DropdownMenuItem<User>(
                        alignment: AlignmentDirectional.center,
                        value: user,
                        child: Text(user.username ?? ''),
                      ))
              .toList(),
          onChanged: (User? newValue) {
            setState(() {
              _selectedBarber = newValue;
            });
          },
        )),
        const SizedBox(
          width: 8,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(213, 178, 99, 1),
          ),
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });
            _loadTerms();
          },
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
                builder: (context) => TermDetailsScreen(
                      barbers: _barbers,
                    )));

            if (_isLoading) {
              setState(() {});
              _loadTerms();

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.0),
                    Text("Term saved successfully.")
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
          child: const Text("Add term"),
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
                      child: Text(
                        'Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Start Time',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'End Time',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Barber',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Booked',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text('Edit',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      'Delete',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
                ],
                rows: (_terms ?? []).map((Term t) {
                  return DataRow(cells: [
                    DataCell(Text(formatDate(t.date))),
                    DataCell(Text(t.startTime?.substring(0, 5) ?? '')),
                    DataCell(Text(t.endTime?.substring(0, 5) ?? '')),
                    DataCell(Text(t.barberName ?? '')),
                    DataCell(
                      Text(
                        t.isBooked == true ? 'Yes' : 'No',
                      ),
                    ),
                    DataCell(IconButton(
                      icon: Icon(
                        Icons.edit_document,
                        color: t.isBooked!
                            ? Colors.grey
                            : const Color.fromRGBO(84, 181, 166, 1),
                      ),
                      onPressed: t.isBooked!
                          ? null
                          : () {
                              _editTerm(t);
                            },
                    )),
                    DataCell(IconButton(
                      icon: Icon(
                        Icons.delete,
                        color:
                            t.isBooked! ? Colors.grey : const Color(0xfff71133),
                      ),
                      onPressed: t.isBooked!
                          ? null
                          : () {
                              _deleteTerm(t);
                            },
                    ))
                  ]);
                }).toList(),
              ),
            ),
          );
  }

  void _editTerm(Term n) async {
    _isLoading = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TermDetailsScreen(
              term: n,
              barbers: _barbers,
            )));
    if (_isLoading) {
      setState(() {});
      _loadTerms();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            SizedBox(width: 8.0),
            Text("Term saved successfully.")
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
  }

  void _deleteTerm(Term t) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete'),
            content: const Text(
                'Are you sure you want to delete this term? This action is not reversible.'),
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
                    await _termProvider.delete(t.id!);

                    setState(() {
                      _terms?.removeWhere((element) => element.id == t.id);
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
                          Text("Term deleted successfully.")
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
                              'Failed to delete news. Please try again.',
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
