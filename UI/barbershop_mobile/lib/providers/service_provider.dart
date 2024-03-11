import 'package:barbershop_mobile/providers/base_provider.dart';

import '../models/service.dart';

class ServiceProvider extends BaseProvider<Service> {
  ServiceProvider() : super("Services");

  @override
  Service fromJson(item) {
    return Service.fromJson(item);
  }
}
