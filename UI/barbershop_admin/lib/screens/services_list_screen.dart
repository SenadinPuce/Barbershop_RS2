// ignore_for_file: use_build_context_synchronously

import 'package:barbershop_admin/models/service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/service_provider.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';
import 'service_detail_screen.dart';

class ServicesListScreen extends StatefulWidget {
  const ServicesListScreen({super.key});

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  late ServiceProvider _serviceProvider;
  List<Service>? services;
  TextEditingController _serviceNameController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    _serviceProvider = context.read<ServiceProvider>();

    var servicesData = await _serviceProvider
        .get(filter: {'name': _serviceNameController.text});

    setState(() {
      services = servicesData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Services',
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            _buildSearch(),
            const SizedBox(
              height: 8,
            ),
            _buildDataListView()
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Row(
      children: [
        Expanded(
            child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Service name',
          ),
          controller: _serviceNameController,
        )),
        const SizedBox(width: 8),
        SizedBox(
          width: 150,
          height: 40,
          child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                _loadServices();
              },
              child: const Text("Search")),
        ),
        const SizedBox(
          width: 8,
        ),
        SizedBox(
          width: 150,
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              isLoading = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ServiceDetailScreen()));
              if (isLoading) {
                setState(() {
                  _loadServices();
                });
              }
            },
            child: const Text("Add new service"),
          ),
        ),
      ],
    );
  }

  Widget _buildDataListView() {
    return Expanded(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  child: DataTable(
                    showCheckboxColumn: false,
                    columns: const [
                      DataColumn(
                          label: Text(
                        'ID',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      )),
                      DataColumn(
                          label: Text(
                        'Name',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      )),
                      DataColumn(
                          label: Text(
                        'Price',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      )),
                      DataColumn(
                          label: Text(
                        'Description',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      )),
                      DataColumn(
                        label: Text('Edit',
                            style: TextStyle(fontStyle: FontStyle.italic)),
                      ),
                      DataColumn(
                          label: Text(
                        'Delete',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      )),
                    ],
                    rows: (services ?? [])
                        .map((Service s) => DataRow(cells: [
                              DataCell(Text(s.id.toString())),
                              DataCell(Text(s.name.toString())),
                              DataCell(Text(formatNumber(s.price))),
                              DataCell(Text(s.description.toString())),
                              DataCell(IconButton(
                                icon: const Icon(
                                  Icons.edit_document,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  _editService(s);
                                },
                              )),
                              DataCell(IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _deleteService(s);
                                },
                              ))
                            ]))
                        .toList(),
                  ),
                ),
              ));
  }

  void _editService(Service s) async {
    isLoading = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ServiceDetailScreen(
              service: s,
            )));
    if (isLoading) {
      setState(() {
        _loadServices();
      });
    }
  }

  void _deleteService(Service s) {
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: const Text('Delete'),
            content: const Text(
                'Are you sure you want to delete this service? This action is not reversible.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No')),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    try {
                      await _serviceProvider.delete(s.id!);

                      setState(() {
                        services?.removeWhere((element) => element.id == s.id);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8.0),
                            Text("Service deleted successfully.")
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
                    } catch (e) {
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
                                'Failed to delete service. Please try again.',
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
                  },
                  child: const Text("Yes"))
            ],
          );
        }));
  }
}
