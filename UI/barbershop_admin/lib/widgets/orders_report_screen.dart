import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../providers/orders_provider.dart';
import '../utils/util.dart';

class OrdersReportScreen extends StatefulWidget {
  const OrdersReportScreen({super.key});

  @override
  State<OrdersReportScreen> createState() => _OrdersReportScreenState();
}

class _OrdersReportScreenState extends State<OrdersReportScreen> {
  late OrderProvider _orderProvider;
  DateTime? _selectedDateFrom;
  DateTime? _selectedDateTo;
  List<Order>? orders;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _orderProvider = context.read<OrderProvider>();
  }

  Future<void> _loadOrders() async {
    var ordersData = await _orderProvider.get(
        filter: {'dateFrom': _selectedDateFrom, 'dateTo': _selectedDateTo});

    setState(() {
      orders = ordersData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildOrderFilters(),
        const SizedBox(
          height: 30,
        ),
        if (isLoading == true)
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else if (orders == null)
          Container()
        else
          Card(
            color: Colors.blue,
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Report',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Period : ${getDate(_selectedDateFrom)} - ${getDate(_selectedDateTo)}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Number of Payed Orders (not shipped yet): ${_getPaymentReceivedOrders()}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Number of Completed Orders : ${_getCompletedOrdersCount()}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Total Revenue: \$${_getTotalRevenue()}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }

  Row _buildOrderFilters() {
    return Row(
      children: [
        Expanded(
            child: DateTimeFormField(
          validator: FormBuilderValidators.required(),
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
            floatingLabelStyle: TextStyle(color: Colors.blue),
            suffixIcon: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Icon(
                Icons.calendar_today,
                color: Colors.blue,
              ),
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
            child: const Text("Generate"),
          ),
        ),
      ],
    );
  }

  int? _getCompletedOrdersCount() {
    return orders?.where((order) => order.status == 'Completed').length;
  }

  int? _getPaymentReceivedOrders() {
    return orders?.where((order) => order.status == 'Payment Received').length;
  }

  double? _getTotalRevenue() {
    return orders
        ?.where((order) =>
            order.status == 'Completed' || order.status == 'Payment Received')
        .map<double>((order) => order.total!)
        .fold(0, (previousValue, element) => previousValue! + element);
  }
}
