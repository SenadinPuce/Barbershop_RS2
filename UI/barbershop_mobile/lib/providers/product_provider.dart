import 'dart:convert';

import 'package:barbershop_mobile/models/product.dart';
import 'package:barbershop_mobile/providers/base_provider.dart';
import 'package:barbershop_mobile/utils/constants.dart';

class ProductProvider extends BaseProvider<Product> {
  ProductProvider() : super("Products");

  @override
  fromJson(item) {
    return Product.fromJson(item);
  }

  Future<List<Product>> recommend(int id) async {
    var url = Uri.parse("${apiUrl}products/$id/recommend");

    Map<String, String> headers = createHeaders();

    var response = await http!.get(url, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = List<Product>() = [];

      for (var item in data) {
        result.add(fromJson(item));
      }
      return result;
    } else {
      throw Exception("Unknown error");
    }
  }
}
