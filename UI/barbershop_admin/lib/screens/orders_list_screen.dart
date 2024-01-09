import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../providers/orders_provider.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';
import 'order_detail_screen.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  late OrderProvider _orderProvider;
  List<Order>? orders;
  bool isLoading = true;
  DateTime? _selectedDateFrom;
  DateTime? _selectedDateTo;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();

    _loadOrders();
  }

  Future<void> _loadOrders() async {
    _orderProvider = context.read<OrderProvider>();

    var ordersData = await _orderProvider.get(filter: {
      'dateFrom': _selectedDateFrom,
      'dateTo': _selectedDateTo,
      'status': _selectedStatus,
      'includeClient': true,
      'includeAddress': true,
      'includeDeliveryMethod': true,
    });

    setState(() {
      orders = ordersData;
      isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null &&
        picked != (isFromDate ? _selectedDateFrom : _selectedDateTo)) {
      setState(() {
        if (isFromDate) {
          _selectedDateFrom = picked;
        } else {
          _selectedDateTo = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Orders',
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
            child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          padding: const EdgeInsets.all(2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'From date: ',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
              Text(
                formatDate(_selectedDateFrom),
                style: const TextStyle(fontSize: 16.0),
              ),
              IconButton(
                  onPressed: () => _selectDate(context, true),
                  icon: const Icon(Icons.calendar_today))
            ],
          ),
        )),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          padding: const EdgeInsets.all(2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'To date: ',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
              Text(
                formatDate(_selectedDateTo),
                style: const TextStyle(fontSize: 16.0),
              ),
              IconButton(
                  onPressed: () => _selectDate(context, false),
                  icon: const Icon(Icons.calendar_today))
            ],
          ),
        )),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
              labelText: "Status",
              contentPadding: const EdgeInsets.all(0),
              suffix: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _selectedStatus = null;
                  });
                },
              ),
              hintText: 'Select status'),
          value: _selectedStatus,
          items: ['Pending', 'Payment Received', 'Payment Failed', 'Completed']
              .map((String value) => DropdownMenuItem(
                    alignment: AlignmentDirectional.center,
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedStatus = newValue;
            });
          },
        )),
        const SizedBox(
          width: 8,
        ),
        SizedBox(
          width: 150,
          height: 40,
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              _loadOrders();
            },
            child: const Text("Search"),
          ),
        ),
      ],
    );
  }

  Widget _buildDataListView() {
    return Expanded(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: DataTable(
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
                        'Client username',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    )),
                    DataColumn(
                        label: Expanded(
                      child: Text(
                        'Client phone number',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    )),
                    DataColumn(
                        label: Expanded(
                      child: Text(
                        'Delivery method',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    )),
                    DataColumn(
                        label: Expanded(
                      child: Text(
                        'Shipping price',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    )),
                    DataColumn(
                        label: Expanded(
                      child: Text(
                        'Subtotal',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    )),
                    DataColumn(
                        label: Expanded(
                      child: Text(
                        'Total',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    )),
                    DataColumn(
                        label: Expanded(
                      child: Text(
                        'Order date',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    )),
                    DataColumn(
                        label: Expanded(
                      child: Text(
                        'Action',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ))
                  ],
                  rows: (orders ?? [])
                      .map((Order o) => DataRow(
                              onSelectChanged: (value) {
                                if (value == true) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          OrderDetailsScreen(order: o)));
                                }
                              },
                              cells: [
                                DataCell(Text(o.id.toString())),
                                DataCell(Text(o.clientUsername.toString())),
                                DataCell(Text(o.clientPhoneNumber.toString())),
                                DataCell(Text(
                                    o.deliveryMethod!.shortName.toString())),
                                DataCell(
                                    Text(o.deliveryMethod!.price.toString())),
                                DataCell(Text(o.subtotal.toString())),
                                DataCell(Text(o.total.toString())),
                                DataCell(Text(getDate(o.orderDate))),
                                DataCell(OutlinedButton(
                                  onPressed: o.status != 'Completed'
                                      ? () async {
                                          var order = await _orderProvider
                                              .updateAppointmentStatus(
                                                  o.id!, 'Completed');

                                          if (order != null) {
                                            setState(() {
                                              o.status = order.status;
                                            });
                                          }
                                        }
                                      : null,
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      disabledBackgroundColor: Colors.grey),
                                  child: const Text(
                                    "Complete",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ))
                              ]))
                      .toList(),
                ),
              ));
  }
}
