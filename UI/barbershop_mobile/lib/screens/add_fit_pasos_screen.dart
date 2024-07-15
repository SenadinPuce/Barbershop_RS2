import 'package:barbershop_mobile/models/user.dart';
import 'package:barbershop_mobile/providers/fit_pasos_provider.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class AddFITPasosScreen extends StatefulWidget {
  const AddFITPasosScreen({super.key, required this.users});
  final List<User> users;

  @override
  State<AddFITPasosScreen> createState() => _AddFITPasosScreenState();
}

class _AddFITPasosScreenState extends State<AddFITPasosScreen> {
  late FITPasosProvider _pasosProvider;
  final _formKey = GlobalKey<FormState>();
  User? _selectedUser;
  DateTime? _selectedDate;
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _pasosProvider = context.read<FITPasosProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj FIT Pasos'),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(children: [
              DropdownButtonFormField<User>(
                validator: FormBuilderValidators.required(
                    errorText: 'Ovo polje je obavezno'),
                decoration: const InputDecoration(
                  labelText: 'Izaberite korisnika',
                ),
                items: widget.users.map((User user) {
                  return DropdownMenuItem<User>(
                    alignment: AlignmentDirectional.center,
                    value: user,
                    child: Text('${user.firstName} ${user.lastName}'),
                  );
                }).toList(),
                value: _selectedUser,
                onChanged: (value) {
                  setState(() {
                    _selectedUser = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                validator: FormBuilderValidators.required(
                    errorText: 'Ovo polje je obavezno'),
                controller: TextEditingController(
                    text: _selectedDate == null
                        ? ''
                        : '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}'),
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.calendar_today),
                    labelText: 'Datum vazenja'),
                onTap: () async {
                  var selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));

                  if (selectedDate != null && selectedDate != _selectedDate) {
                    setState(() {
                      _selectedDate = selectedDate;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text('Je li pasos validan ?'),
                  const SizedBox(
                    width: 10,
                  ),
                  Checkbox(
                      value: _isValid,
                      onChanged: (value) {
                        setState(() {
                          _isValid = value!;
                        });
                      })
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var request = {
                            'korisnikId': _selectedUser!.id,
                            'datumVazenja': _selectedDate!.toIso8601String(),
                            'isValid': _isValid
                          };

                          await _pasosProvider.insert(request: request);

                          if (!context.mounted) return;
                          Navigator.of(context).pop(true);
                        }
                      },
                      child: const Text("Sacuvaj"))
                ],
              )
            ]),
          )),
    );
  }
}
