import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/appointment.dart';
import '../models/user.dart';
import '../providers/appointment_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/master_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AppointmentProvider _appointmentProvider;
  late UserProvider _userProvider;
  List<User>? _barbersList;
  DateTime? _selectedDateFrom;
  DateTime? _selectedDateTo;
  User? _selectedBarber;
  List<Appointment>? appointments;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        isLoading = false;
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
    return MasterScreenWidget(
      title: 'Reports',
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  decoration:
                      const BoxDecoration(color: Colors.lightBlueAccent),
                  child: TabBar(
                    controller: _tabController,
                    indicator: const BoxDecoration(color: Colors.blue),
                    labelColor: Colors.white,
                    tabs: const [
                      Tab(
                        text: 'Generate barbers report',
                        icon: Icon(Icons.work_rounded),
                      ),
                      Tab(
                        text: 'Generate orders report',
                        icon: Icon(Icons.show_chart_rounded),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBarbersDataView(),
                      _buildOrdersDataView(),
                    ],
                  ),
                ))
              ],
            ),
    );
  }

  Widget _buildBarbersDataView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _builderBarbersFilter(),
        const SizedBox(
          height: 30,
        ),
        appointments == null
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Report',
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Number of Completed Appointments: ${_getCompletedAppointmentsCount()}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Number of Minutes Worked: ${_getNumberOfMinutesWorked()}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Total Income Made: \$${_getTotalIncome()}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              )
      ],
    );
  }

  Row _builderBarbersFilter() {
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

  Widget _buildOrdersDataView() {
    return const Text("Data");
  }
}
