// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/appointment_provider.dart';
import '../providers/user_provider.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';

class AppointmentDetailScreen extends StatefulWidget {
  List<User>? barbers;
  AppointmentDetailScreen({
    super.key,
    this.barbers,
  });

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late AppointmentProvider _appointmentProvider;
  List<User>? _barbersList;
  bool isLoading = true;
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    _appointmentProvider = context.read<AppointmentProvider>();

    _loadAppointmentDetails();
  }

  Future<void> _loadAppointmentDetails() async {
    _barbersList = widget.barbers;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Appointment details',
      child: Padding(
          padding: const EdgeInsets.all(15),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    const SizedBox(height: 15),
                    _buildForm(),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 40,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.blue),
                            ),
                            child: const Text("Close"),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                          width: 150,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState?.saveAndValidate() ==
                                  true) {
                                String formattedDateTime =
                                    DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'")
                                        .format(DateTime(
                                            _selectedDate.year,
                                            _selectedDate.month,
                                            _selectedDate.day,
                                            _selectedTime.hour,
                                            _selectedTime.minute,
                                            _selectedTime.second,
                                            _selectedTime.microsecond ~/ 1000));

                                var request =
                                    Map.from(_formKey.currentState!.value);

                                request['startTime'] = formattedDateTime;

                                try {
                                  await _appointmentProvider.insert(
                                      request: request);

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text("Appointment saved successfully."),
                                    backgroundColor: Colors.green,
                                  ));
                                } on Exception catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Failed to save appoinemnt. Please try again.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text("Save changes"),
                          ),
                        )
                      ],
                    )
                  ],
                )),
    );
  }

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      child: Column(children: [
        Row(
          children: [
            Expanded(
                child: DateTimeFormField(
              decoration: const InputDecoration(
                labelText: 'Select date',
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
              initialValue: DateTime.now(),
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
                child: DateTimeFormField(
              decoration: const InputDecoration(
                labelText: 'Select time',
                floatingLabelStyle: TextStyle(color: Colors.blue),
                suffixIcon: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Icon(
                    Icons.access_time,
                    color: Colors.blue,
                  ),
                ),
              ),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
              dateFormat: DateFormat('h:mm a'),
              initialValue: DateTime.now(),
              mode: DateTimeFieldPickerMode.time,
              onDateSelected: (value) {
                setState(() {
                  _selectedTime = value;
                });
              },
            )),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          children: [
            Expanded(
              child: FormBuilderTextField(
                  name: 'durationInMinutes',
                  decoration: const InputDecoration(
                    labelText: 'Duration (minutes)',
                    contentPadding: EdgeInsets.all(0),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.integer(),
                  ])),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: FormBuilderDropdown<int>(
              name: 'barberId',
              validator: FormBuilderValidators.required(),
              decoration: InputDecoration(
                  labelText: 'Choose barber',
                  contentPadding: const EdgeInsets.all(0),
                  suffix: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _formKey.currentState?.fields['barberId']?.reset();
                    },
                  ),
                  hintText: 'Select barber'),
              items: _barbersList!
                  .map((item) => DropdownMenuItem(
                        value: item.id,
                        alignment: AlignmentDirectional.center,
                        child: Text(item.username ?? ""),
                      ))
                  .toList(),
            ))
          ],
        )
      ]),
    );
  }
}
