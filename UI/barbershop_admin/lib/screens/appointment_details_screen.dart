// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/appointment.dart';
import '../models/user.dart';
import '../providers/appointment_provider.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  List<User>? barbers;
  AppointmentDetailsScreen({
    super.key,
    this.barbers,
  });

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late AppointmentProvider _appointmentProvider;
  List<User>? _barbersList;
  Appointment? editedAppointment;
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();
  bool isLoading = true;

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
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildForm(),
                    const SizedBox(height: 20),
                    _buildButtons()
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
                hintText: 'Select date',
                floatingLabelStyle:
                    TextStyle(color: Color.fromRGBO(213, 178, 99, 1)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                suffixIcon: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Icon(Icons.calendar_today,
                      color: Color.fromRGBO(213, 178, 99, 1)),
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
                hintText: 'Select time',
                floatingLabelStyle:
                    TextStyle(color: Color.fromRGBO(213, 178, 99, 1)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                suffixIcon: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Icon(Icons.calendar_today,
                      color: Color.fromRGBO(213, 178, 99, 1)),
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
          crossAxisAlignment: CrossAxisAlignment.end,
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
                labelText: "Barber",
                hintText: 'Select barber',
                alignLabelWithHint: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                suffix: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _formKey.currentState?.fields['barberId']?.reset();
                  },
                ),
              ),
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

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 150,
          height: 40,
          child: OutlinedButton(
            onPressed: () {
              if (editedAppointment != null) {
                Navigator.of(context).pop(true);
              } else {
                Navigator.of(context).pop(false);
              }
            },
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
              if (_formKey.currentState?.saveAndValidate() == true) {
                String formattedDateTime =
                    DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                        _selectedTime.hour,
                        _selectedTime.minute,
                        _selectedTime.second,
                        _selectedTime.microsecond ~/ 1000));

                var request = Map.from(_formKey.currentState!.value);

                request['startTime'] = formattedDateTime;

                try {
                  editedAppointment =
                      await _appointmentProvider.insert(request: request);

                  setState(() {});

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.0),
                        Text("Appointment saved successfully.")
                      ],
                    ),
                    duration: const Duration(seconds: 1),
                    backgroundColor: Colors.green,
                    action: SnackBarAction(
                      label: 'Dismiss',
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                      textColor: Colors.white,
                    ),
                  ));
                } on Exception catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Failed to save appointment. Please try again.',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      duration: const Duration(seconds: 1),
                      backgroundColor: Colors.red,
                      action: SnackBarAction(
                        label: 'Dismiss',
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                        textColor: Colors.white,
                      ),
                    ),
                  );
                }
              }
            },
            child: const Text("Save changes"),
          ),
        )
      ],
    );
  }
}
