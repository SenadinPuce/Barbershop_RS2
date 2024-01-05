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
  const AppointmentDetailScreen({super.key});

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late AppointmentProvider _appointmentProvider;
  late UserProvider _userProvider;
  List<User> _barbersList = [];
  bool isLoading = true;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();

    _appointmentProvider = context.read<AppointmentProvider>();
    _userProvider = context.read<UserProvider>();

    _initialValue = {
      'date': formatDate(_selectedDate),
      'time': formatTime(_selectedTime)
    };

    _loadAppointmentDetails();
  }

  Future<void> _loadAppointmentDetails() async {
    if (_barbersList.isEmpty) {
      var barbers =
          await _userProvider.getUsers(filter: {'roleName': 'barber'});
      _barbersList.addAll(barbers);
    }

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
          child: Column(
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
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                      child: const Text("Cancel"),
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
                              DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(
                                  DateTime(
                                      _selectedDate.year,
                                      _selectedDate.month,
                                      _selectedDate.day,
                                      _selectedTime.hour,
                                      _selectedTime.minute,
                                      _selectedDate.second,
                                      _selectedDate.microsecond ~/ 1000));

                          var request = Map.from(_formKey.currentState!.value);

                          request['startTime'] = formattedDateTime;

                          try {
                            await _appointmentProvider.insert(request: request);

                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Appointment saved successfully."),
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
      initialValue: _initialValue,
      child: Column(children: [
        Row(
          children: [
            Expanded(
                child: FormBuilderTextField(
              name: 'date',
              readOnly: true,
              validator: FormBuilderValidators.required(),
              decoration: InputDecoration(
                labelText: 'Select Date',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100));
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      _selectedDate = pickedDate;
                      String formattedDate =
                          DateFormat('dd-MMM-yyyy').format(pickedDate);
                      _formKey.currentState!.fields['date']
                          ?.didChange(formattedDate);
                    }
                  },
                ),
              ),
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: FormBuilderTextField(
                name: 'time',
                readOnly: true,
                validator: FormBuilderValidators.required(),
                decoration: InputDecoration(
                    labelText: 'Select Time',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                            context: context, initialTime: _selectedTime);
                        if (pickedTime != null && pickedTime != _selectedTime) {
                          _selectedTime = pickedTime;
                          String formattedTime = pickedTime.format(context);
                          _formKey.currentState!.fields['time']
                              ?.didChange(formattedTime);
                        }
                      },
                    )),
              ),
            )
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
              items: _barbersList
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
