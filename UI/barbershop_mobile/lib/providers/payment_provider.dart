// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:barbershop_mobile/models/customer_payment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../utils/constants.dart';
import '../utils/util.dart';

class PaymentProvider with ChangeNotifier {
  String baseUrl = '${apiUrl}payments/';

  HttpClient client = HttpClient();
  IOClient? http;

  PaymentProvider() {
    client.badCertificateCallback = (cert, host, port) => true;
    http = IOClient(client);
  }

  Future<CustomerPayment> insert({dynamic request, String? extraRoute}) async {
    var uri = Uri.parse(baseUrl);

    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http!.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return CustomerPayment.fromJson(data);
    } else {
      throw Exception("Unknown error");
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

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    } else {
      print("Error response: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception("Something bad happened, please try again");
    }
  }
}
