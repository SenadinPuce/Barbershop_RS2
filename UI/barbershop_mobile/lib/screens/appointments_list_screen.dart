import 'package:barbershop_mobile/models/appointment.dart';
import 'package:barbershop_mobile/models/service.dart';
import 'package:barbershop_mobile/providers/appointment_provider.dart';
import 'package:barbershop_mobile/providers/service_provider.dart';
import 'package:barbershop_mobile/screens/user_appointments_screen.dart';
import 'package:barbershop_mobile/utils/util.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class AppointmentsListScreen extends StatefulWidget {
  static const routeName = '/appointments';
  const AppointmentsListScreen({super.key});

  @override
  State<AppointmentsListScreen> createState() => _AppointmentsListScreen();
}

class _AppointmentsListScreen extends State<AppointmentsListScreen> {
  late AppointmentProvider _appointmentProvider;
  late ServiceProvider _serviceProvider;
  List<Service>? _services;
  List<Appointment>? _appointments;
  Service? _selectedService;
  DateTime? _selectedDate;
  late List<GlobalKey<FormFieldState>> _dropdownKeys;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    _serviceProvider = context.read<ServiceProvider>();
    _appointmentProvider = context.read<AppointmentProvider>();

    if (_services == null) {
      var servicesData = await _serviceProvider.get();
      _services = servicesData;
    }

    var appointmentsData = await _appointmentProvider.get(filter: {
      'dateFrom': _selectedDate,
      'dateTo': _selectedDate,
      'status': 'Free'
    });

    setState(() {
      _appointments = appointmentsData;
      _dropdownKeys = List.generate(
          _appointments!.length, (index) => GlobalKey<FormFieldState>());
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearch(),
            _buildView(),
            const SizedBox(
              height: 80,
            )
          ],
        )),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          PersistentNavBarNavigator.pushNewScreen(context,
              screen: const UserAppointmentsScreen());
        },
        backgroundColor: const Color.fromRGBO(99, 134, 213, 1),
        label: const Text("Your Appointments"),
        icon: const Icon(Icons.calendar_today),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: const Center(
        child: Text(
          "Appointments",
          style: TextStyle(color: Colors.black, fontSize: 35),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: DateTimeField(
              decoration: const InputDecoration(
                  labelText: 'Select date',
                  floatingLabelStyle: TextStyle(color: Colors.blue),
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: Color.fromRGBO(213, 178, 99, 1),
                  )),
              dateFormat: DateFormat('dd MMM yyyy'),
              mode: DateTimeFieldPickerMode.date,
              onDateSelected: (value) {
                setState(() {
                  _selectedDate = value;
                });
                loadData();
              },
              selectedDate: _selectedDate,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildView() {
    if (isLoading) {
      return Container();
    } else {
      if (_appointments != null && _appointments!.isNotEmpty) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _appointments!.asMap().entries.map((entry) {
              final int index = entry.key;
              final Appointment appointment = entry.value;

              return _buildAppointmentCard(index, appointment);
            }).toList());
      } else {
        return Container(
          margin: const EdgeInsets.only(top: 30),
          child: const Center(
            child: Text(
              'No appointments available.',
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }
    }
  }

  Widget _buildAppointmentCard(int index, Appointment a) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Card(
          elevation: 2.0,
          color: Colors.blueGrey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                      ),
                      title: Text('Date: ${formatDate(a.startTime) ?? ''}'),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.access_time,
                        color: Colors.black,
                      ),
                      title: Text(
                          'Time: ${formatTime(a.startTime)} - ${formatTime(a.endTime)}'),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      title: Text('Barber: ${a.barberFullName ?? ''}'),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black,
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<Service>(
                      key: _dropdownKeys[index],
                      validator: FormBuilderValidators.required(),
                      decoration: InputDecoration(
                          labelText: 'Select service',
                          border: const OutlineInputBorder(),
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                _selectedService = null;
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                            ),
                          )),
                      items: _services?.map((Service service) {
                        return DropdownMenuItem<Service>(
                          alignment: AlignmentDirectional.center,
                          value: service,
                          child: Text(
                              '${service.name.toString()} - ${service.price.toString()} \$'),
                        );
                      }).toList(),
                      value: _selectedService,
                      onChanged: (value) {
                        setState(() {
                          _selectedService = value;
                        });
                      },
                    )),
                const Divider(
                  color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF54b5a6),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        minimumSize: const Size(double.infinity, 45),
                        elevation: 3),
                    onPressed: () async {
                      if (_dropdownKeys[index].currentState!.validate()) {
                        Map request = {
                          "ClientId": Authorization.id,
                          "ServiceId": _selectedService?.id,
                          "Status": "Reserved"
                        };

                        await _appointmentProvider.update(a.id!,
                            request: request);

                        setState(() {
                          _appointments?.removeWhere(
                              (appointment) => appointment.id == a.id);
                          _selectedService = null;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.green,
                              showCloseIcon: true,
                              closeIconColor: Colors.white,
                              duration: Duration(seconds: 2),
                              content:
                                  Text('Appointment reserved successfully')),
                        );
                      }
                    },
                    child: const Text(
                      'Book now',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
