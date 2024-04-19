// ignore_for_file: use_build_context_synchronously

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../providers/orders_provider.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';
import 'order_details_screen.dart';

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

    loadOrders();
  }

  Future<void> loadOrders() async {
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
      ),
    );
  }

  Widget _buildSearch() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
            child: DateTimeFormField(
          decoration: const InputDecoration(
            labelText: 'From date',
            hintText: 'Select date',
            floatingLabelStyle:
                TextStyle(color: Color.fromRGBO(213, 178, 99, 1)),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            suffixIcon: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Icon(Icons.calendar_today,
                  color: Color.fromRGBO(213, 178, 99, 1)),
            ),
          ),
          initialValue: _selectedDateFrom,
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
            hintText: 'Select date',
            floatingLabelStyle:
                TextStyle(color: Color.fromRGBO(213, 178, 99, 1)),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            suffixIcon: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Icon(Icons.calendar_today,
                  color: Color.fromRGBO(213, 178, 99, 1)),
            ),
          ),
          initialValue: _selectedDateTo,
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
            hintText: 'Select status',
            alignLabelWithHint: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            suffix: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _selectedStatus = null;
                });
              },
            ),
          ),
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(213, 178, 99, 1),
          ),
          onPressed: () async {
            setState(() {
              isLoading = true;
            });
            loadOrders();
          },
          child: const Text("Search"),
        ),
      ],
    );
  }

  Widget _buildDataListView() {
    return isLoading
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
                    'ID',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text(
                    'Client',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text(
                    'Delivery method',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    softWrap: true,
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text('Order date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      softWrap: true),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text(
                    'Complete',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text(
                    'Details',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ))
              ],
              rows: (orders ?? [])
                  .map((Order o) => DataRow(cells: [
                        DataCell(Text(o.id.toString())),
                        DataCell(Text(o.clientUsername.toString())),
                        DataCell(Text(o.deliveryMethod!.shortName.toString())),
                        DataCell(Text(o.total.toString())),
                        DataCell(Text(getDate(o.orderDate))),
                        DataCell(Text(o.status.toString())),
                        DataCell(IconButton(
                          icon: const Icon(Icons.check_box_outlined),
                          color: const Color.fromRGBO(84, 181, 166, 1),
                          disabledColor: Colors.grey,
                          onPressed: (o.status == 'Payment Received')
                              ? () {
                                  _completeOrder(o);
                                }
                              : null,
                        )),
                        DataCell(IconButton(
                            icon: const Icon(Icons.info),
                            color: const Color.fromRGBO(99, 134, 213, 1),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      OrderDetailsScreen(order: o)));
                            }))
                      ]))
                  .toList(),
            ),
          ));
  }

  void _completeOrder(Order o) {
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: const Text(
                'Are you sure you want to mark this order as completed? This action is not reversible.'),
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
                      var order = await _orderProvider.updateAppointmentStatus(
                          o.id!, 'Completed');

                      setState(() {
                        o.status = order.status;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8.0),
                            Text("Order status updated successfully.")
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
                                'Failed to update order status. Please try again.',
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
