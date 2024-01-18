// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
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
  Service? editedService;

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
                        if (editedService != null) {
                          Navigator.of(context).pop(true);
                        } else {
                          Navigator.of(context).pop(false);
                        }
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
                            var request =
                                Map.from(_formKey.currentState!.value);

                            try {
                              if (widget.service == null) {
                                editedService = await _serviceProvider.insert(
                                    request: request);
                              } else {
                                editedService = await _serviceProvider.update(
                                    widget.service!.id!, request);
                              }

                              setState(() {});

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8.0),
                                    Text("Service saved successfully.")
                                  ],
                                ),
                                duration: const Duration(seconds: 1),
                                backgroundColor: Colors.green,
                                action: SnackBarAction(
                                  label: 'Dismiss',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
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
                                        'Failed to save service. Please try again.',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
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
                  FormBuilderValidators.match(
                      r'^(?=\D*(?:\d\D*){1,12}$)\d+(?:\.\d{1,4})?$',
                      errorText: 'Enter a valid decimal number'),
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
