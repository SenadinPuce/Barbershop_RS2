// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:barbershop_admin/widgets/master_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../models/service.dart';
import '../providers/service_provider.dart';
import '../utils/util.dart';

class ServiceDetailScreen extends StatefulWidget {
  Service? service;
  ServiceDetailScreen({
    Key? key,
    this.service,
  }) : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late ServiceProvider _serviceProvider;
  bool hasChanges = false;

  @override
  void initState() {
    super.initState();

    _initialValue = {
      'name': widget.service?.name,
      'price': formatNumber(widget.service?.price).toString(),
      'description': widget.service?.description,
    };

    _serviceProvider = context.read<ServiceProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Service details",
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
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
                        onPressed: hasChanges
                            ? () async {
                                if (_formKey.currentState?.saveAndValidate() ==
                                    true) {
                                  var request =
                                      Map.from(_formKey.currentState!.value);

                                  try {
                                    if (widget.service == null) {
                                      await _serviceProvider.insert(
                                          request: request);
                                    } else {
                                      await _serviceProvider.update(
                                          widget.service!.id!, request);
                                    }

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content:
                                          Text("Service saved successfully."),
                                      backgroundColor: Colors.green,
                                    ));
                                  } on Exception catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Failed to save barbers service. Please try again.'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                            : null,
                        child: const Text("Save changes"),
                      )),
                ],
              )
            ],
          ),
        ));
  }

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      onChanged: () {
        setState(() {
          hasChanges = !mapEquals(_initialValue, _formKey.currentState!.value);
        });
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: FormBuilderTextField(
                name: 'name',
                validator: FormBuilderValidators.required(),
                decoration: const InputDecoration(labelText: 'Name'),
              )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: FormBuilderTextField(
                name: 'price',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric()
                ]),
                decoration: const InputDecoration(labelText: 'Price'),
              )),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          FormBuilderTextField(
            name: 'description',
            validator: FormBuilderValidators.required(),
            maxLines: 5,
            decoration: InputDecoration(
                labelText: 'Description',
                hintText: _initialValue['description'] != null
                    ? ''
                    : 'Enter your description here',
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
          ),
        ],
      ),
    );
  }
}
