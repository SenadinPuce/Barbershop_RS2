import 'dart:convert';
import 'dart:math';
import 'package:barbershop_admin/helpers/constants.dart';
import 'package:barbershop_admin/utils/util.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AccountProvider with ChangeNotifier {
  String baseUrl = '${apiUrl}account/';

  AccountProvider();

  Future<void> loginAsync(String username, String password) async {
    String endpoint = '${baseUrl}login';

    var headers = createHeaders();

    final body = jsonEncode({
      'username': username,
      'password': password,
    });

      final response =
          await http.post(Uri.parse(endpoint), headers: headers, body: body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        User.username = data['username'];
        User.email = data['email'];
        User.token = data['token'];

        // Successful login
        print('Login successful! Token: ${User.username}');
      } else {
        // Handle error
        print(
            'Login failed. Status code: ${response.statusCode}, Body: ${response.body}');

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
