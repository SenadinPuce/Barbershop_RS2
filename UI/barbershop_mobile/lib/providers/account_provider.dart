import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../models/address.dart';
import '../utils/constants.dart';
import '../utils/util.dart';

class AccountProvider with ChangeNotifier {
  String baseUrl = '${apiUrl}account/';

  HttpClient client = HttpClient();
  IOClient? http;

  AccountProvider() {
    client.badCertificateCallback = (cert, host, port) => true;
    http = IOClient(client);
  }

  Future<void> login(String username, String password) async {
    String endpoint = '${baseUrl}login';

    var headers = createHeaders();
    var uri = Uri.parse(endpoint);

    final body = jsonEncode({'username': username, 'password': password});

    final response = await http?.post(uri, headers: headers, body: body);

    if (response?.statusCode == 200) {
      var data = jsonDecode(response!.body);

      Authorization.id = data['id'];
      Authorization.username = data['username'];
      Authorization.email = data['email'];
      Authorization.token = data['token'];
    } else {
      throw Exception("Login failed");
    }
  }

  Future<void> register(dynamic request) async {
    String endpoint = '${baseUrl}register';

    var headers = createHeaders();
    var uri = Uri.parse(endpoint);

    final body = jsonEncode(request);

    final response = await http?.post(uri, headers: headers, body: body);

    if (response?.statusCode == 200) {
      var data = jsonDecode(response!.body);

      Authorization.id = data['id'];
      Authorization.username = data['username'];
      Authorization.email = data['email'];
      Authorization.token = data['token'];
    } else {
      throw Exception("Registration failed");
    }
  }

  Map<String, String> createHeaders() {
    var headers = {
      "Content-Type": "application/json",
    };

    String token = Authorization.token ?? "";

    if (token.isNotEmpty) {
      String jwtAuth = "Bearer $token";
      headers["Authorization"] = jwtAuth;
    }

    return headers;
  }

  Future<Address> getAddress() async {
    String endpoint = '${baseUrl}address';

    var headers = createHeaders();

    var uri = Uri.parse(endpoint);

    final response = await http?.get(uri, headers: headers);

    if (response?.statusCode == 200) {
      Address address = Address.fromJson(jsonDecode(response!.body));
      return address;
    } else {
      throw Exception("Failed to fetch address");
    }
  }

  Future<Address> updateAddress(dynamic update) async {
    String endpoint = '${baseUrl}address';

    var headers = createHeaders();
    var uri = Uri.parse(endpoint);

    final body = jsonEncode(update);

    final response = await http!.put(uri, headers: headers, body: body);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return Address.fromJson(data);
    } else {
      throw Exception("Failed to update address");
    }
  }

  Future<void> update({required dynamic request}) async {
    var uri = Uri.parse('${apiUrl}account');
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http!.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      Authorization.id = data['id'];
      Authorization.username = data['username'];
      Authorization.email = data['email'];
      Authorization.token = data['token'];
    } else {
      throw Exception("Unknown error");
    }
  }

  bool isValidResponse(Response response) {
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
