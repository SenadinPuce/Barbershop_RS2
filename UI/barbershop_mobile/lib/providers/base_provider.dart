// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:barbershop_mobile/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../utils/util.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String? _endpoint;

  HttpClient client = HttpClient();
  IOClient? http;

  BaseProvider(String endpoint) {
    _baseUrl = apiUrl;

    if (_baseUrl!.endsWith("/") == false) {
      _baseUrl = "$_baseUrl/";
    }

    _endpoint = endpoint;
    client.badCertificateCallback = (cert, host, port) => true;
    http = IOClient(client);
  }

  Future<T> getById(int id) async {
    var url = Uri.parse("$_baseUrl$_endpoint/$id");

    Map<String, String> headers = createHeaders();

    var response = await http!.get(url, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<List<T>> get({dynamic filter, String? extraRoute}) async {
    var url = "$_baseUrl$_endpoint";

    if (extraRoute != null && extraRoute.trim().isEmpty == false) {
      url = "$url/$extraRoute";
    }

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = List<T>() = [];

      for (var item in data) {
        result.add(fromJson(item));
      }
      return result;
    } else {
      throw Exception("Unknown error");
    }
  }

  Map<String, String> createHeaders() {
    String token = Authorization.token ?? "";

    String jwtAuth = "Bearer ${base64Encode(utf8.encode(token))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": jwtAuth
    };

    return headers;
  }

  T fromJson(item) {
    throw Exception("Method not implemented");
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

  String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value as DateTime).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }
}
