import 'dart:convert';

import 'package:barbershop_admin/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../helpers/constants.dart';

import 'base_provider.dart';

class ProductProvider extends BaseProvider<Product> {
  ProductProvider() : super("Products");

  @override
  fromJson(item) {
    // TODO: implement fromJson
    return Product.fromJson(item);
  }
}
