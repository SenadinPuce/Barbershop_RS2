import 'package:barbershop_mobile/models/appointment.dart';
import 'package:barbershop_mobile/models/service.dart';
import 'package:barbershop_mobile/providers/appointment_provider.dart';
import 'package:barbershop_mobile/providers/service_provider.dart';
import 'package:barbershop_mobile/screens/user_appointments_screen.dart';
import 'package:barbershop_mobile/utils/util.dart';
import 'package:barbershop_mobile/widgets/master_screen.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppointmentsScreen extends StatefulWidget {
  static const routeName = '/appointments';
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  late AppointmentProvider _appointmentProvider;
  late ServiceProvider _serviceProvider;
  List<Service>? _services;
  List<Appointment>? _appointments;
  Service? _selectedService;
  DateTime? _selectedDate;
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
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Stack(children: [
        SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildHeader(), _buildSearch(), _buildView()],
        )),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, UserAppointmentsScreen.routeName);
            },
            backgroundColor: Colors.amber[700],
            child: const Icon(
              Icons.calendar_month,
            ),
          ),
        )
      ]),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Center(
        child: Text(
          "Appointments",
          style: GoogleFonts.tiltNeon(color: Colors.black, fontSize: 35),
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
                    Icons.calendar_month,
                    color: Colors.blue,
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
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if (_appointments != null && _appointments!.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _appointments!.map((a) {
            return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  elevation: 5.0,
                  color: Colors.grey[200],
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
                              title: Text(
                                  'Date: ${formatDate(a.startTime) ?? ''}'),
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
                              title: Text('Barber: ${a.barberUsername ?? ''}'),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<Service>(
                              decoration: InputDecoration(
                                  labelText: 'Select service',
                                  border: const OutlineInputBorder(),
                                  suffix: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedService = null;
                                      });
                                    },
                                    icon: const Icon(Icons.close),
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
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                minimumSize: const Size(double.infinity, 40),
                                elevation: 3),
                            onPressed: () async {
                              if (_selectedService != null) {
                                Map request = {
                                  "ClientId": Authorization.id,
                                  "ServiceId": _selectedService?.id,
                                  "Status": "Reserved"
                                };

                                await _appointmentProvider.update(a.id!,
                                    request: request);
                                loadData();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.blueGrey,
                                      content: Text('Please select a service')),
                                );
                              }
                            },
                            child: const Text('Book now'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          }).toList(),
        );
      } else {
        return const Center(
          child: Text('No appointments available.'),
        );
      }
    }
  }
}
