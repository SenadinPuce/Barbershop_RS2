import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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

    final response = await http?.put(uri, headers: headers, body: body);

    if (response?.statusCode == 200) {
      Address address = Address.fromJson(jsonDecode(response!.body));
      return address;
    } else if (response?.statusCode == 400) {
      throw Exception("Problem updating the address");
    } else {
      throw Exception("Failed to update address");
    }
  }
}
