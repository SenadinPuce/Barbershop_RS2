import 'package:barbershop_admin/providers/base_provider.dart';

import '../models/service.dart';

class ServiceProvider extends BaseProvider<Service> {
  ServiceProvider() : super("Services");

  @override Service fromJson(data) {
    return Service.fromJson(data);
  }
}
