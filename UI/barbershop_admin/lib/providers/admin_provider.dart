import 'package:barbershop_admin/providers/base_provider.dart';

import '../models/user.dart';

class AdminProvider extends BaseProvider<User> {
  AdminProvider() : super("admin");

  @override
  User fromJson(item) {
    return User.fromJson(item);
  }

  Future<List<User>> getUsers({dynamic filter}) async {
    return await get(filter: filter, extraRoute: "users-with-roles");
  }

  Future<User> updateUserRoles(String? username, String? roles) async {
    return await insert(request: roles, extraRoute: "edit-roles/$username");
  }
}
