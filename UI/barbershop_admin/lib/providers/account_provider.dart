import 'dart:convert';
import 'package:barbershop_admin/helpers/constants.dart';
import 'package:barbershop_admin/utils/util.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AccountProvider with ChangeNotifier {
  String baseUrl = '${apiUrl}account/';

  AccountProvider();

  Future<void> loginAdminAsync(String username, String password) async {
    String endpoint = '${baseUrl}login/admin';

    var headers = createHeaders();

    final body = jsonEncode({
      'username': username,
      'password': password,
    });

    final response =
        await http.post(Uri.parse(endpoint), headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      Authorization.id = data['id'];
      Authorization.username = data['username'];
      Authorization.email = data['email'];
      Authorization.token = data['token'];
    } else {
      throw Exception("Login failed");
    }
  }

  Map<String, String> createHeaders() {
    final headers = {
      'accept': 'text/plain',
      'Content-Type': 'application/json',
    };

    return headers;
  }
}
