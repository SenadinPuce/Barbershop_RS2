import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/appointment.dart';
import '../models/user.dart';
import '../providers/appointment_provider.dart';
import '../providers/user_provider.dart';
import '../utils/util.dart';

class BarbersReportScreen extends StatefulWidget {
  const BarbersReportScreen({super.key});

  @override
  State<BarbersReportScreen> createState() => _BarbersReportScreenState();
}

class _BarbersReportScreenState extends State<BarbersReportScreen> {
  late AppointmentProvider _appointmentProvider;
  late UserProvider _userProvider;
  List<User>? _barbersList;
  DateTime? _selectedDateFrom;
  DateTime? _selectedDateTo;
  User? _selectedBarber;
  List<Appointment>? appointments;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _appointmentProvider = context.read<AppointmentProvider>();
    _userProvider = context.read<UserProvider>();

    _loadBarbers();
  }

  Future<void> _loadBarbers() async {
    if (_barbersList == null) {
      var barbers =
          await _userProvider.getUsers(filter: {'roleName': 'barber'});
      setState(() {
        _barbersList = List.from(barbers);
      });
    }
  }

  Future<void> _loadAppointments() async {
    var appointmentsData = await _appointmentProvider.get(filter: {
      'dateFrom': _selectedDateFrom,
      'dateTo': _selectedDateTo,
      'barberId': _selectedBarber?.id
    });

    setState(() {
      appointments = appointmentsData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildBarberFilters(),
        const SizedBox(
          height: 30,
        ),
        if (isLoading == true)
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else if (appointments == null)
          Container()
        else
          Card(
            color: Colors.blue,
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Report',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Period : ${getDate(_selectedDateFrom)} - ${getDate(_selectedDateTo)}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Number of Completed Appointments: ${_getCompletedAppointmentsCount()}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Minutes Worked: ${_getNumberOfMinutesWorked()}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Total Income Made: \$${_getTotalIncome()}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }

  Row _buildBarberFilters() {
    return Row(
      children: [
        Expanded(
            child: DateTimeFormField(
          validator: FormBuilderValidators.required(),
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
            child: const Text("Generate"),
          ),
        ),
      ],
    );
  }

  int? _getCompletedAppointmentsCount() {
    return appointments
        ?.where((appointment) => appointment.status == 'Completed')
        .length;
  }

  int? _getNumberOfMinutesWorked() {
    return appointments
        ?.where((appointment) => appointment.status == 'Completed')
        .map<int>((appointment) => appointment.durationInMinutes!)
        .fold(0, (previousValue, element) => previousValue! + element);
  }

  double? _getTotalIncome() {
    return appointments
        ?.where((appointment) => appointment.status == 'Completed')
        .map<double>((appointment) => appointment.servicePrice!)
        .fold(0, (previousValue, element) => previousValue! + element);
  }
}
