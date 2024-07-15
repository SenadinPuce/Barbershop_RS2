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
}
