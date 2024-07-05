import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/term.dart';
import '../models/user.dart';
import '../providers/term_provider.dart';

class TermDetailsScreen extends StatefulWidget {
  final Term? term;
  final List<User>? barbers;

  const TermDetailsScreen({super.key, this.term, this.barbers});

  @override
  State<TermDetailsScreen> createState() => _TermDetailsScreenState();
}

class _TermDetailsScreenState extends State<TermDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late TermProvider _termProvider;
  List<User>? _barbers;
  Term? _editedTerm;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();

    _barbers = widget.barbers;

    _initialValue = {
      'date': widget.term?.date,
      'startTime': widget.term?.startTime != null
          ? DateFormat('hh:mm').parse(widget.term!.startTime!)
          : null,
      'endTime': widget.term?.endTime != null
          ? DateFormat('hh:mm').parse(widget.term!.endTime!)
          : null,
      'barberId': widget.term?.barberId,
    };

    _termProvider = context.read<TermProvider>();
  }

  void _updateEndTime(DateTime? startTime) {
    if (startTime != null) {
      final newEndTime = startTime.add(const Duration(minutes: 20));
      _formKey.currentState?.fields['endTime']?.didChange(newEndTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildForm(),
            const SizedBox(height: 20),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: FormBuilderDateTimePicker(
                  name: 'date',
                  decoration: const InputDecoration(
                    labelText: 'To date',
                    floatingLabelStyle:
                        TextStyle(color: Color.fromRGBO(213, 178, 99, 1)),
                    suffixIcon: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(Icons.calendar_today,
                          color: Color.fromRGBO(213, 178, 99, 1)),
                    ),
                  ),
                  validator: FormBuilderValidators.required(),
                  format: DateFormat('dd MMM yyyy'),
                  inputType: InputType.date,
                ),
              ),
              const SizedBox(width: 10),
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
                items: _barbers!
                    .map((item) => DropdownMenuItem(
                          value: item.id,
                          alignment: AlignmentDirectional.center,
                          child: Text(item.username ?? ""),
                        ))
                    .toList(),
              ))
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: FormBuilderDateTimePicker(
                  name: 'startTime',
                  validator: FormBuilderValidators.required(),
                  inputType: InputType.time,
                  decoration: const InputDecoration(
                    labelText: 'Start time',
                    floatingLabelStyle:
                        TextStyle(color: Color.fromRGBO(213, 178, 99, 1)),
                    suffixIcon: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(Icons.access_time,
                          color: Color.fromRGBO(213, 178, 99, 1)),
                    ),
                  ),
                  onChanged: (val) {
                    _updateEndTime(val);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FormBuilderDateTimePicker(
                  name: 'endTime',
                  validator: FormBuilderValidators.required(),
                  inputType: InputType.time,
                  decoration: const InputDecoration(
                    labelText: 'End time',
                    floatingLabelStyle:
                        TextStyle(color: Color.fromRGBO(213, 178, 99, 1)),
                    suffixIcon: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(Icons.access_time,
                          color: Color.fromRGBO(213, 178, 99, 1)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: _isSending
              ? null
              : () {
                  if (_editedTerm != null) {
                    Navigator.of(context).pop(true);
                  } else {
                    Navigator.of(context).pop(false);
                  }
                },
          child: const Text("Cancel"),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _isSending
              ? null
              : () async {
                  if (_formKey.currentState?.saveAndValidate() == true) {
                    setState(() {
                      _isSending = true;
                    });

                    var request = Map.from(_formKey.currentState!.value);
                    request['date'] =
                        DateFormat('yyyy-MM-dd').format(request['date']);
                    request['startTime'] =
                        DateFormat('HH:mm:ss').format(request['startTime']);
                    request['endTime'] =
                        DateFormat('HH:mm:ss').format(request['endTime']);

                    try {
                      if (widget.term == null) {
                        _editedTerm =
                            await _termProvider.insert(request: request);
                      } else {
                        _editedTerm = await _termProvider.update(
                            widget.term!.id!, request);
                      }

                      if (!context.mounted) return;

                      Navigator.of(context).pop(true);
                    } on Exception {
                      setState(() {
                        _isSending = false;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Failed to save term. Please try again.',
                            style: TextStyle(color: Colors.white),
                          ),
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.red,
                          action: SnackBarAction(
                            label: 'Dismiss',
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            },
                            textColor: Colors.white,
                          ),
                        ),
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
              : const Text("Save"),
        ),
      ],
    );
  }
}
