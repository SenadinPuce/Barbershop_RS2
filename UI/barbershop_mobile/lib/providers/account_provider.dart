import 'dart:convert';
import 'dart:io';

import 'package:barbershop_mobile/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';

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
