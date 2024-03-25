import '../models/order.dart';
import 'base_provider.dart';

class OrderProvider extends BaseProvider<Order> {
  OrderProvider() : super("Orders");

  @override
  Order fromJson(item) {
    return Order.fromJson(item);
  }

  Future<Order> updateAppointmentStatus(int orderId, String status) async {
    return await update(orderId, request:status, extraRoute: 'update-status');
  }
}