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
      Authorization.roles = List<String>.from(data['roles']);
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

    String token = Authorization.token ?? "";

    if (token.isNotEmpty) {
      String jwtAuth = "Bearer $token";
      headers['Authorization'] = jwtAuth;
    }

    return headers;
  }

  Future<bool> register(dynamic request) async {
    String endpoint = '${baseUrl}register';

    var headers = createHeaders();
    var uri = Uri.parse(endpoint);

    final body = jsonEncode(request);

    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Registration failed");
    }
  }

  Future<void> update({required dynamic request}) async {
    var uri = Uri.parse('${apiUrl}account');
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      Authorization.id = data['id'];
      Authorization.username = data['username'];
      Authorization.email = data['email'];
      Authorization.roles = List<String>.from(data['roles']);
      Authorization.token = data['token'];
    } else {
      throw Exception("Unknown error");
    }
  }

  bool isValidResponse(http.Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    } else if (response.statusCode == 400) {
      throw Exception("Bad request: ${response.body}");
    } else if (response.statusCode == 403) {
      throw Exception("Forbidden method: ${response.body}");
    } else if (response.statusCode == 404) {
      throw Exception("Not found: ${response.body}");
    } else if (response.statusCode == 500) {
      throw Exception("Internal server error: ${response.body}");
    } else {
      throw Exception("Something bad happened, please try again");
    }
  }
}
