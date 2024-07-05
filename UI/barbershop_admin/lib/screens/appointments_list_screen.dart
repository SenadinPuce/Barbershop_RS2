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
  DateTime? _selectedDate;
  User? _selectedBarber;
  bool? _selectedStatus;
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
      'date': _selectedDate,
      'barberId': _selectedBarber?.id,
      'isCanceled': _selectedStatus,
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
            labelText: 'Select reservation date',
            hintText: 'Select reservation date',
            floatingLabelStyle:
                TextStyle(color: Color.fromRGBO(213, 178, 99, 1)),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            suffixIcon: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Icon(Icons.calendar_today,
                  color: Color.fromRGBO(213, 178, 99, 1)),
            ),
          ),
          initialValue: _selectedDate,
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
            child: DropdownButtonFormField<bool?>(
          decoration: InputDecoration(
            labelText: "Status",
            hintText: 'Select status',
            alignLabelWithHint: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            suffix: IconButton(
                onPressed: () => {
                      setState(() {
                        _selectedStatus = null;
                      })
                    },
                icon: const Icon(Icons.close)),
          ),
          value: _selectedStatus,
          items: [
            const DropdownMenuItem<bool?>(
              alignment: AlignmentDirectional.center,
              value: null,
              child: Text('All'),
            ),
            const DropdownMenuItem<bool?>(
              alignment: AlignmentDirectional.center,
              value: false,
              child: Text('Reserved'),
            ),
            const DropdownMenuItem<bool?>(
              alignment: AlignmentDirectional.center,
              value: true,
              child: Text('Canceled'),
            ),
          ].toList(),
          onChanged: (bool? newValue) {
            setState(() {
              _selectedStatus = newValue;
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
                    'Start Time',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text(
                    'End Time',
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
                    'Client',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text(
                    'Reservation Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text(
                    'Canceled',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
              ],
              rows: (appointments ?? [])
                  .map((Appointment a) => DataRow(cells: [
                        DataCell(Text(getDate(a.date))),
                        DataCell(Text(a.startTime?.substring(0, 5) ?? '')),
                        DataCell(Text(a.endTime?.substring(0, 5) ?? '')),
                        DataCell(Text(a.serviceName ?? '')),
                        DataCell(Text(a.clientName ?? '')),
                        DataCell(Text(getDate(a.reservationDate))),
                        DataCell(Text(a.isCanceled == true ? 'Yes' : 'No')),
                      ]))
                  .toList(),
            ),
          ));
  }
}
