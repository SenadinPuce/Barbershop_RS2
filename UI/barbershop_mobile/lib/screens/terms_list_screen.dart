import 'package:barbershop_mobile/models/term.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:date_field/date_field.dart';
import 'package:provider/provider.dart';

import '../models/service.dart';
import '../providers/appointment_provider.dart';
import '../providers/service_provider.dart';
import '../providers/term_provider.dart';
import '../utils/util.dart';
import '../widgets/custom_app_bar.dart';
import 'reservation_success.dart';

class TermsListScreen extends StatefulWidget {
  static const routeName = '/terms';
  final int? barberId;
  const TermsListScreen({super.key, required this.barberId});

  @override
  State<TermsListScreen> createState() => _TermsListScreen();
}

class _TermsListScreen extends State<TermsListScreen> {
  late TermProvider _termProvider;
  late AppointmentProvider _appointmentProvider;
  late ServiceProvider _serviceProvider;
  List<Term>? _terms;
  List<Service>? _services;
  Service? _selectedService;
  DateTime? _selectedDate;
  late List<GlobalKey<FormFieldState>> _dropdownKeys;
  bool _isLoading = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _termProvider = context.read<TermProvider>();
    _appointmentProvider = context.read<AppointmentProvider>();
    _serviceProvider = context.read<ServiceProvider>();

    if (_services == null) {
      var servicesData = await _serviceProvider.get();
      _services = servicesData;
    }

    var termsData = await _termProvider.get(filter: {
      'date': _selectedDate,
      'barberId': widget.barberId,
      'isBooked': false,
    });

    setState(() {
      _terms = termsData;
      _dropdownKeys =
          List.generate(_terms!.length, (index) => GlobalKey<FormFieldState>());
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Terms'),
      body: Stack(children: [
        SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildSearch(),
            _buildView(),
            const SizedBox(
              height: 80,
            )
          ],
        )),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ]),
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
                  _isLoading = true;
                });
                _loadData();
              },
              selectedDate: _selectedDate,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildView() {
    if (_isLoading) {
      return Container();
    } else {
      if (_terms != null && _terms!.isNotEmpty) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _terms!.asMap().entries.map((entry) {
              final int index = entry.key;
              final Term term = entry.value;

              return _buildAppointmentCard(index, term);
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

  Widget _buildAppointmentCard(int index, Term t) {
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
                ListTile(
                  leading: const Icon(
                    Icons.calendar_month,
                    color: Colors.black,
                  ),
                  title: Text('Date: ${formatDate(t.date)}'),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.access_time,
                    color: Colors.black,
                  ),
                  title: Text(
                      'Time: ${t.startTime?.substring(0, 5)} - ${t.endTime?.substring(0, 5)}'),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<Service>(
                      key: _dropdownKeys[index],
                      validator: FormBuilderValidators.required(
                          errorText: 'Select service.'),
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
                      elevation: 3,
                    ),
                    onPressed: _isSending
                        ? null
                        : () async {
                            if (_dropdownKeys[index].currentState!.validate()) {
                              try {
                                setState(() {
                                  _isSending = true;
                                });
                                Map request = {
                                  "ClientId": Authorization.id,
                                  "ServiceId": _selectedService?.id,
                                  "TermId": t.id,
                                };

                                await _appointmentProvider.insert(
                                    request: request);

                                setState(() {
                                  _terms
                                      ?.removeWhere((term) => term.id == t.id);
                                  _selectedService = null;
                                  _isSending = false;
                                });

                                if (!context.mounted) return;
                                
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ReservationSuccessScreen(),
                                    ),
                                    (route) => route.isFirst);
                              } on Exception {
                                setState(() {
                                  _isSending = false;
                                });

                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.red,
                                      showCloseIcon: true,
                                      closeIconColor: Colors.white,
                                      duration: Duration(seconds: 1),
                                      content: Text(
                                          'Failed to update delivery address. Please try again.')),
                                );
                              }
                            }
                          },
                    child: _isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text(
                            'Book now',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
