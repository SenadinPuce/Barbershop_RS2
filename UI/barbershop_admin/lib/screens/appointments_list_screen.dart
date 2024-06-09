// ignore_for_file: use_build_context_synchronously
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/appointment.dart';
import '../models/user.dart';
import '../providers/appointment_provider.dart';
import '../providers/user_provider.dart';
import '../utils/util.dart';

class AppointmentsListScreen extends StatefulWidget {
  const AppointmentsListScreen({super.key});

  @override
  State<AppointmentsListScreen> createState() => _AppointmentsListScreenState();
}

class _AppointmentsListScreenState extends State<AppointmentsListScreen> {
  late AppointmentProvider _appointmentProvider;
  late UserProvider _userProvider;
  List<Appointment>? appointments;
  List<User>? _barbersList;
  DateTime? _selectedDateFrom;
  DateTime? _selectedDateTo;
  String? _selectedStatus;
  User? _selectedBarber;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    _appointmentProvider = context.read<AppointmentProvider>();
    _userProvider = context.read<UserProvider>();

    if (_barbersList == null) {
      var barbers =
          await _userProvider.getUsers(filter: {'roleName': 'barber'});
      setState(() {
        _barbersList = List.from(barbers);
      });
    }

    var appointmentsData = await _appointmentProvider.get(filter: {
      'dateFrom': _selectedDateFrom,
      'dateTo': _selectedDateTo,
      'status': _selectedStatus,
      'barberId': _selectedBarber?.id
    });

    setState(() {
      appointments = appointmentsData;
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
            child: DateTimeFormField(
          decoration: const InputDecoration(
            labelText: 'From date',
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
          initialValue: _selectedDateFrom,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          dateFormat: DateFormat('dd MMM yyyy'),
          mode: DateTimeFieldPickerMode.date,
          onDateSelected: (value) {
            setState(() {
              _selectedDateFrom = value;
            });
          },
        )),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: DateTimeFormField(
          decoration: const InputDecoration(
            labelText: 'To date',
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
          initialValue: _selectedDateTo,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          dateFormat: DateFormat('dd MMM yyyy'),
          mode: DateTimeFieldPickerMode.date,
          onDateSelected: (value) {
            setState(() {
              _selectedDateTo = value;
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
          items: _barbersList
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
            _loadAppointments();
          },
          child: const Text("Search"),
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
                    'Time',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text(
                    'Service',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text(
                    'Barber',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text(
                    'Client',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text(
                    'Complete',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
              ],
              rows: (appointments ?? [])
                  .map((Appointment a) => DataRow(cells: [
                        DataCell(Text(getDate(a.startTime))),
                        DataCell(Text(getTime(a.startTime))),
                        DataCell(SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: a.services!.map((service) {
                              return Text(
                                '${service.name}',
                              );
                            }).toList(),
                          ),
                        )),
                        DataCell(Text(a.barberFullName.toString())),
                        DataCell(Text(a.clientFullName?.toString() ?? '')),
                        DataCell(Text(a.status.toString())),
                        DataCell(IconButton(
                          icon: const Icon(
                            Icons.check_box_outlined,
                          ),
                          color: const Color.fromRGBO(84, 181, 166, 1),
                          disabledColor: Colors.grey,
                          onPressed: (a.status == 'Reserved' &&
                                  a.endTime!.isBefore(DateTime.now()))
                              ? () {
                                  _completeAppointment(a);
                                }
                              : null,
                        )),
                      ]))
                  .toList(),
            ),
          ));
  }

  void _completeAppointment(Appointment a) {
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: const Text(
                'Are you sure you want to mark this appointment as completed? This action is not reversible.'),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No')),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    try {
                      var appointment = await _appointmentProvider
                          .update(a.id!, {'status': 'Completed'});

                      setState(() {
                        a.status = appointment.status;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8.0),
                            Text("Appointment status updated successfully.")
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
                                'Failed to update appointment status. Please try again.',
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
                  child: const Text("Yes"))
            ],
          );
        }));
  }
}
