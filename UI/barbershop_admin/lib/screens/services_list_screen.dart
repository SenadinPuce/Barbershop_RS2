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
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
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
                              ]))
                      .toList(),
                ),
              ));
  }
}