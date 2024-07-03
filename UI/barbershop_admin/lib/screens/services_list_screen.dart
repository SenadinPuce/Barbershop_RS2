import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/service.dart';
import '../providers/service_provider.dart';
import '../utils/util.dart';
import 'service_details_screen.dart';

class ServicesListScreen extends StatefulWidget {
  const ServicesListScreen({super.key});

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  late ServiceProvider _serviceProvider;
  List<Service>? _services;
  final TextEditingController _serviceNameController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadServices();
  }

  Future<void> loadServices() async {
    _serviceProvider = context.read<ServiceProvider>();

    var servicesData = await _serviceProvider
        .get(filter: {'name': _serviceNameController.text});

    setState(() {
      _services = servicesData;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearch(),
            const SizedBox(
              height: 20,
            ),
            _buildDataListView()
          ],
        ));
  }

  Widget _buildSearch() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
            child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Service name',
            hintText: 'Enter service name',
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          ),
          controller: _serviceNameController,
        )),
        const SizedBox(width: 8),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(213, 178, 99, 1),
            ),
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              loadServices();
            },
            child: const Text("Search")),
        const SizedBox(
          width: 8,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(84, 181, 166, 1),
          ),
          onPressed: () async {
            _isLoading = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ServiceDetailsScreen()));
            if (_isLoading) {
              setState(() {});
              loadServices();

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  textColor: Colors.white,
                ),
              ));
            }
          },
          child: const Text("Add service"),
        ),
      ],
    );
  }

  Widget _buildDataListView() {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                showCheckboxColumn: false,
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) {
                    return const Color.fromRGBO(236, 239, 241, 1);
                  },
                ),
                columns: const [
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      'Price',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      'Duration (minutes)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  )),
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
                  DataColumn(
                    label: Expanded(
                      child: Text('Edit',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      'Delete',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
                ],
                rows: (_services ?? [])
                    .map((Service s) => DataRow(cells: [
                          DataCell(Text(s.name.toString())),
                          DataCell(Text(formatNumber(s.price))),
                          DataCell(Text(s.durationInMinutes.toString())),
                          DataCell(Text(s.description.toString())),
                          DataCell(IconButton(
                            icon: const Icon(
                              Icons.edit_document,
                              color: Color.fromRGBO(84, 181, 166, 1),
                            ),
                            onPressed: () {
                              _editService(s);
                            },
                          )),
                          DataCell(IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Color(0xfff71133),
                            ),
                            onPressed: () {
                              _deleteService(s);
                            },
                          ))
                        ]))
                    .toList(),
              ),
            ),
          );
  }

  void _editService(Service s) async {
    _isLoading = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ServiceDetailsScreen(
              service: s,
            )));
    if (_isLoading) {
      setState(() {});
      loadServices();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          textColor: Colors.white,
        ),
      ));
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
              OutlinedButton(
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
                        _services?.removeWhere((element) => element.id == s.id);
                      });

                      if (!context.mounted) return;

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
