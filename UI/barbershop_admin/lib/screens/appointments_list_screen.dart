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
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AppointmentDetailScreen(barbers: _barbersList,)));
            },
            child: const Text("Add new appointment"),
          ),
        )
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
              label: Expanded(
            child: Text(
              'ID',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          )),
          DataColumn(
              label: Expanded(
            child: Text(
              'Appointment date',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          )),
          DataColumn(
              label: Expanded(
            child: Text(
              'Start time',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          )),
          DataColumn(
              label: Expanded(
            child: Text(
              'End time',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          )),
          DataColumn(
              label: Expanded(
            child: Text(
              'Duration in minutes',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          )),
          DataColumn(
              label: Expanded(
            child: Text(
              'Barber username',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          )),
          DataColumn(
              label: Expanded(
            child: Text(
              'Client username',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          )),
          DataColumn(
              label: Expanded(
            child: Text(
              'Status',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          )),
          DataColumn(
              label: Expanded(
            child: Text(
              'Complete',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          )),
          DataColumn(
              label: Expanded(
            child: Text(
              'Delete',
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
                  DataCell(Text(a.durationInMinutes.toString())),
                  DataCell(Text(a.barberUsername.toString())),
                  DataCell(Text(a.clientUsername?.toString() ?? '')),
                  DataCell(Text(a.status.toString())),
                  DataCell(_completeAppointment(a)),
                  DataCell(_deleteAppointment(a))
                ]))
            .toList(),
      ),
    ));
  }

  Widget _completeAppointment(Appointment a) {
    return OutlinedButton(
      onPressed: a.status == 'Reserved'
          ? () async {
              bool confirm = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmation'),
                      content: const Text(
                          'Are you sure you want to mark the appointment as completed? This action is not reversible.'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text("No")),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text("Yes")),
                      ],
                    );
                  });

              if (confirm == true) {
                var appointment = await _appointmentProvider
                    .updateAppointmentStatus(a.id!, 'Completed');

                setState(() {
                  a.status = appointment.status;
                });
              }
            }
          : null,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.green,
        disabledBackgroundColor: Colors.grey,
      ),
      child: const Text(
        "Complete",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _deleteAppointment(Appointment a) {
    return OutlinedButton(
      onPressed: a.endTime!.isBefore(DateTime.now()) ||
              a.status == 'Free' ||
              a.status == 'Canceled'
          ? () async {
              bool confirm = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmation'),
                      content: const Text(
                          'Are you sure you want to delete the appointment? This action is not reversible.'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text("No")),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text("Yes")),
                      ],
                    );
                  });

              if (confirm == true) {
                var appointment = await _appointmentProvider.delete(a.id!);

                if (appointment != null) {
                  setState(() {
                    appointments?.removeWhere((element) => element.id == a.id);
                  });
                }
              }
            }
          : null,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.red,
        disabledBackgroundColor: Colors.grey,
      ),
      child: const Text(
        "Delete",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
