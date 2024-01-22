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
import '../widgets/master_screen.dart';
import 'appointment_detail_screen.dart';

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
  bool isLoading = true;

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
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Appointments',
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
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
            child: DateTimeFormField(
          decoration: const InputDecoration(
            labelText: 'From date',
            floatingLabelStyle: TextStyle(color: Colors.blue),
            suffixIcon: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Icon(
                Icons.calendar_today,
                color: Colors.blue,
              ),
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
            floatingLabelStyle: TextStyle(color: Colors.blue),
            suffixIcon: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Icon(
                Icons.calendar_today,
                color: Colors.blue,
              ),
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
              contentPadding: const EdgeInsets.all(0),
              suffix: IconButton(
                  onPressed: () => {
                        setState(() {
                          _selectedBarber = null;
                        })
                      },
                  icon: const Icon(Icons.close)),
              hintText: 'Select barber'),
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
        Expanded(
            child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
              labelText: "Status",
              contentPadding: const EdgeInsets.all(0),
              suffix: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _selectedStatus = null;
                  });
                },
              ),
              hintText: 'Select status'),
          value: _selectedStatus,
          items: ['Free', 'Reserved', 'Completed', 'Canceled']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              alignment: AlignmentDirectional.center,
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedStatus = newValue ?? '';
            });
          },
        )),
        const SizedBox(
          width: 8,
        ),
        SizedBox(
          width: 150,
          height: 40,
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              _loadAppointments();
            },
            child: const Text("Search"),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        SizedBox(
          width: 150,
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              isLoading = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AppointmentDetailScreen(
                        barbers: _barbersList,
                      )));

              if (isLoading) {
                setState(() {
                  _loadAppointments();
                });
              }
            },
            child: const Text("Add new appointment"),
          ),
        )
      ],
    );
  }

  Widget _buildDataListView() {
    return Expanded(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    showCheckboxColumn: false,
                    columns: const [
                      DataColumn(
                          label: Expanded(
                        child: Text(
                          'ID',
                          softWrap: true,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      )),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Appointment date',
                            softWrap: true,
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      DataColumn(
                          label: Expanded(
                        child: Text(
                          'Start time',
                          softWrap: true,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      )),
                      DataColumn(
                          label: Expanded(
                        child: Text(
                          'End time',
                          softWrap: true,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      )),
                      DataColumn(
                          label: Expanded(
                        child: Text(
                          'Service name',
                          softWrap: true,
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      )),
                      DataColumn(
                          label: Expanded(
                        child: Text(
                          'Service price',
                          softWrap: true,
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      )),
                      DataColumn(
                          label: Expanded(
                        child: Text(
                          'Barber username',
                          softWrap: true,
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      )),
                      DataColumn(
                          label: Expanded(
                        child: Text(
                          'Client username',
                          softWrap: true,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      )),
                      DataColumn(
                          label: Expanded(
                        child: Text(
                          'Status',
                          softWrap: true,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      )),
                      DataColumn(
                          label: Expanded(
                        child: Text(
                          'Complete',
                          softWrap: true,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      )),
                      DataColumn(
                          label: Expanded(
                        child: Text(
                          'Delete',
                          softWrap: true,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ))
                    ],
                    rows: (appointments ?? [])
                        .map((Appointment a) => DataRow(cells: [
                              DataCell(Text(a.id.toString())),
                              DataCell(Text(getDate(a.startTime))),
                              DataCell(Text(getTime(a.startTime))),
                              DataCell(Text(getTime(a.endTime))),
                              DataCell(Text(a.serviceName != null
                                  ? a.serviceName.toString()
                                  : '')),
                              DataCell(Text(a.servicePrice.toString())),
                              DataCell(Text(a.barberUsername.toString())),
                              DataCell(
                                  Text(a.clientUsername?.toString() ?? '')),
                              DataCell(Text(a.status.toString())),
                              DataCell(IconButton(
                                icon: const Icon(
                                  Icons.check_box_outlined,
                                ),
                                color: Colors.green,
                                disabledColor: Colors.grey,
                                onPressed: (a.status == 'Reserved' &&
                                        a.endTime!.isBefore(DateTime.now()))
                                    ? () {
                                        _completeAppointment(a);
                                      }
                                    : null,
                              )),
                              DataCell(
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                  ),
                                  color: Colors.red,
                                  disabledColor: Colors.grey,
                                  onPressed: a.status == 'Free'
                                      ? () => _deleteAppointment(a)
                                      : null,
                                ),
                              )
                            ]))
                        .toList(),
                  ),
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
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No')),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    try {
                      var appointment = await _appointmentProvider
                          .updateAppointmentStatus(a.id!, 'Completed');

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

  void _deleteAppointment(Appointment a) {
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: const Text('Delete'),
            content: const Text(
                'Are you sure you want to delete this appointment? This action is not reversible.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No')),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    try {
                      await _appointmentProvider.delete(a.id!);

                      setState(() {
                        appointments
                            ?.removeWhere((element) => element.id == a.id);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8.0),
                              Text("Appointment deleted successfully.")
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
                      });
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
                                'Failed to delete appointment. Please try again.',
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
                  child: const Text('Yes'))
            ],
          );
        }));
  }
}
