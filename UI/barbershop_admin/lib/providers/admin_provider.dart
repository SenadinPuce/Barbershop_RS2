import 'package:barbershop_admin/providers/base_provider.dart';

import '../models/user.dart';

class AdminProvider extends BaseProvider<User> {
  AdminProvider() : super("admin");

  @override
  User fromJson(item) {
    return User.fromJson(item);
  }
}
