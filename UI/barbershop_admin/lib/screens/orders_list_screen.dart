import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
            child: DateTimeFormField(
          decoration: const InputDecoration(
            labelText: 'From date',
            floatingLabelStyle: TextStyle(color: Colors.blue),
            suffixIcon: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Icon(
                Icons.calendar_today,
                color: Colors.blue,
              ),
            ),
          ),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          dateFormat: DateFormat('dd MMM yyyy'),
          mode: DateTimeFieldPickerMode.date,
          onDateSelected: (value) {
            setState(() {
              _selectedDateFrom = value;
            });
          },
        )),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: DateTimeFormField(
          decoration: const InputDecoration(
            labelText: 'To date',
            floatingLabelStyle: TextStyle(color: Colors.blue),
            suffixIcon: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Icon(
                Icons.calendar_today,
                color: Colors.blue,
              ),
            ),
          ),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          dateFormat: DateFormat('dd MMM yyyy'),
          mode: DateTimeFieldPickerMode.date,
          onDateSelected: (value) {
            setState(() {
              _selectedDateTo = value;
            });
          },
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
                        'Status',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    )),
                    DataColumn(
                        label: Expanded(
                      child: Text(
                        'Complete order',
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
                                DataCell(Text(
                                    o.deliveryMethod!.shortName.toString())),
                                DataCell(
                                    Text(o.deliveryMethod!.price.toString())),
                                DataCell(Text(o.subtotal.toString())),
                                DataCell(Text(o.total.toString())),
                                DataCell(Text(getDate(o.orderDate))),
                                DataCell(Text(o.status.toString())),
                                DataCell(
                                  o.status != 'Payment Received'
                                      ? Container()
                                      : OutlinedButton(
                                          onPressed: () async {
                                            bool confirm = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      "Confirmation"),
                                                  content: const Text(
                                                      "Are you sure you want to mark the order as completed? This action is not reversible."),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(true);
                                                      },
                                                      child: const Text("Yes"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                      child: const Text("No"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (confirm == true) {
                                              var order = await _orderProvider
                                                  .updateAppointmentStatus(
                                                o.id!,
                                                'Completed',
                                              );

                                              setState(() {
                                                o.status = order.status;
                                              });
                                            }
                                          },
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            disabledBackgroundColor:
                                                Colors.grey,
                                          ),
                                          child: const Text(
                                            "Complete",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                )
                              ]))
                      .toList(),
                ),
              ));
  }
}
