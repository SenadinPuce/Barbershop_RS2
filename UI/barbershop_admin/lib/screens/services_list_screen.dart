import 'package:barbershop_admin/models/service.dart';
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
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ServiceDetailScreen()));
            },
            child: const Text("Add new service"),
          ),
        ),
      ],
    );
  }

  Widget _buildDataListView() {
    return Expanded(
        child: SingleChildScrollView(
      child: DataTable(
        columnSpacing: 215,
        showCheckboxColumn: false,
        columns: const [
          DataColumn(
              label: Expanded(
            child: Text(
              'ID',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          )),
          DataColumn(
              label: Expanded(
            child: Text(
              'Name',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          )),
          DataColumn(
              label: Expanded(
            child: Text(
              'Price',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          )),
          DataColumn(
              label: Expanded(
            child: Text(
              'Description',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          )),
          DataColumn(
              label: Expanded(
            child: Text(
              'Delete',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          )),
        ],
        rows: (services ?? [])
            .map((Service s) => DataRow(
                    onSelectChanged: (value) {
                      if (value == true) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ServiceDetailScreen(
                                  service: s,
                                )));
                      }
                    },
                    cells: [
                      DataCell(Text(s.id.toString())),
                      DataCell(Text(s.name.toString())),
                      DataCell(Text(formatNumber(s.price))),
                      DataCell(Text(s.description.toString())),
                      DataCell(_deleteService(s))
                    ]))
            .toList(),
      ),
    ));
  }

  Widget _deleteService(Service s) {
    return OutlinedButton(
      onPressed: () async {
        bool confirm = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirmation'),
                content: const Text(
                    'Are you sure you want to delete the service? This action is not reversible.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text("No")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("Yes")),
                ],
              );
            });

        if (confirm == true) {
          var service = await _serviceProvider.delete(s.id!);

          if (service != null) {
            setState(() {
              services?.removeWhere((element) => element.id == s.id);
            });
          }
        }
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.red,
        disabledBackgroundColor: Colors.grey,
      ),
      child: const Text(
        "Delete",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
