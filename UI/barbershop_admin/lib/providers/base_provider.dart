// ignore_for_file: prefer_final_fields, unused_field
import 'dart:convert';
import 'package:barbershop_admin/helpers/constants.dart';
import 'package:barbershop_admin/utils/util.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  String _endpoint = "";

  BaseProvider(String endpoint) {
    _endpoint = endpoint;
  }

  Future<List<T>> get({dynamic filter, String? extraRoute}) async {
    var url = "$apiUrl$_endpoint";

    if (extraRoute != null && extraRoute.trim().isEmpty == false) {
      url = "$url/$extraRoute";
    }

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

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

  Future<T> insert({dynamic request, String? extraRoute}) async {
    var url = "$apiUrl$_endpoint";

    if (extraRoute != null && extraRoute.trim().isEmpty == false) {
      url = "$url/$extraRoute";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<T> update(int id, [dynamic request, String? extraRoute]) async {
    var url = "$apiUrl$_endpoint/$id";

    if (extraRoute != null && extraRoute.trim().isEmpty == false) {
      url = "$url/$extraRoute";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<T> delete(int id, {String? extraRoute}) async {
    var url = "$apiUrl$_endpoint/$id";

    if (extraRoute != null && extraRoute.trim().isNotEmpty) {
      url = "$url/$extraRoute";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.delete(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
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

  T fromJson(item) {
    throw Exception("Method not implemented");
  }
}
