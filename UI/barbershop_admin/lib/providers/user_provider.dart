import '../models/user.dart';
import 'base_provider.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("Users");

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
