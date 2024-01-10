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
  List<User> _barbersList = [];
  bool isLoading = true;
  DateTime? _selectedDateFrom;
  DateTime? _selectedDateTo;
  String? _selectedStatus = 'All';
  User _selectedBarber = User(id: 0, username: 'All');

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    _appointmentProvider = context.read<AppointmentProvider>();
    _userProvider = context.read<UserProvider>();

    if (_barbersList.isEmpty) {
      var barbers =
          await _userProvider.getUsers(filter: {'roleName': 'barber'});
      _barbersList.add(User(id: 0, username: 'All'));
      _barbersList.addAll(barbers);
    }

    var appointmentsData = await _appointmentProvider.get(filter: {
      'dateFrom': _selectedDateFrom,
      'dateTo': _selectedDateTo,
      'status': (_selectedStatus == 'All') ? '' : _selectedStatus,
      'barberId': (_selectedBarber.id == 0) ? '' : _selectedBarber.id
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
          items: _barbersList.map<DropdownMenuItem<User>>((User user) {
            return DropdownMenuItem<User>(
              value: user,
              child: Text(user.username ?? ''),
            );
          }).toList(),
          onChanged: (User? newValue) {
            setState(() {
              _selectedBarber = newValue ?? User(id: 0, username: 'All');
            });
          },
          decoration: const InputDecoration(
            labelText: "Barber",
            contentPadding: EdgeInsets.all(0),
          ),
        )),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: DropdownButtonFormField<String>(
          items: ['All', 'Free', 'Reserved', 'Completed', 'Canceled']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedStatus = newValue ?? '';
            });
          },
          decoration: const InputDecoration(
            labelText: "Status",
            contentPadding: EdgeInsets.all(0),
          ),
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
                  builder: (context) => const AppointmentDetailScreen()));
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
                        'Action',
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
                            DataCell(OutlinedButton(
                              onPressed: a.status != 'Completed'
                                  ? () async {
                                      var appointment =
                                          await _appointmentProvider
                                              .updateAppointmentStatus(
                                                  a.id!, 'Completed');

                                      if (appointment != null) {
                                        setState(() {
                                          a.status = appointment.status;
                                        });
                                      }
                                    }
                                  : null,
                              style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.green,
                                  side: const BorderSide(color: Colors.green),
                                  disabledForegroundColor: Colors.grey),
                              child: const Text("Complete"),
                            ))
                          ]))
                      .toList(),
                ),
              ));
  }
}
