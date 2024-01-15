import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/appointment.dart';
import '../models/order.dart';
import '../models/user.dart';
import '../providers/appointment_provider.dart';
import '../providers/orders_provider.dart';
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
  late OrderProvider _orderProvider;
  List<User>? _barbersList;
  DateTime? _selectedDateFrom;
  DateTime? _selectedDateTo;
  User? _selectedBarber;
  List<Appointment>? appointments;
  List<Order>? orders;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _appointmentProvider = context.read<AppointmentProvider>();
    _userProvider = context.read<UserProvider>();
    _orderProvider = context.read<OrderProvider>();

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

  Future<void> _loadOrders() async {
    var ordersData = await _orderProvider.get(
        filter: {'dateFrom': _selectedDateFrom, 'dateTo': _selectedDateTo});

    setState(() {
      orders = ordersData;
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

  // barbers view

  Widget _buildBarbersDataView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildBarberFilter(),
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Number of Reserved Appointments: ${_getReservedAppointmentsCount()}',
                    style: const TextStyle(fontSize: 18),
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

  Row _buildBarberFilter() {
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

  int? _getReservedAppointmentsCount() {
    return appointments
        ?.where((appointment) => appointment.status == 'Reserved')
        .length;
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

  // Orders view

  Widget _buildOrdersDataView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildOrderFilter(),
        const SizedBox(
          height: 30,
        ),
        orders == null
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Report',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Number of Payed Orders: ${_getPaymentReceivedOrders()}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Number of Completed Orders: ${_getCompletedOrdersCount()}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Average Order Value: \$${_getAverageOrderValue()}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Total Revenue: \$${_getTotalRevenue()}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              )
      ],
    );
  }

  Row _buildOrderFilter() {
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
              _loadOrders();
            },
            child: const Text("Generate"),
          ),
        ),
      ],
    );
  }

  int? _getCompletedOrdersCount() {
    return orders?.where((order) => order.status == 'Completed').length;
  }

  int? _getPaymentReceivedOrders() {
    return orders?.where((order) => order.status == 'Payment Received').length;
  }

  double? _getAverageOrderValue() {
    if (orders == null) {
      return 0.0;
    }

    double totalRevenue = orders!
        .where((order) =>
            order.status == 'Completed' || order.status == 'Payment Received')
        .map<double>((order) => (order.total as num).toDouble())
        .fold(0, (previousValue, element) => previousValue + element);

    return totalRevenue /
        (orders
            ?.where((order) =>
                order.status == 'Completed' ||
                order.status == 'Payment Received')
            .length as num);
  }

  double? _getTotalRevenue() {
    return orders
        ?.where((order) =>
            order.status == 'Completed' || order.status == 'Payment Received')
        .map<double>((order) => order.total!)
        .fold(0, (previousValue, element) => previousValue! + element);
  }
}
