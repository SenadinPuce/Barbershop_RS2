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

  Future<Product> setMainPhoto(int productId, int photoId) async {
    var url = "${apiUrl}products/${productId}/photo/${photoId}";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(null);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<Product> deletePhoto(int productId, int photoId) async {
    return await delete(productId, extraRoute: 'photo/$photoId');
  }

  Future<Product> uploadProductPhoto(int productId, File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${apiUrl}Products/$productId/photo'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          imageFile.path,
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(await response.stream.bytesToString());
        var updatedProduct = Product.fromJson(jsonResponse);

        return updatedProduct;
      } else {
        throw Exception(
            'Failed to upload photo. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to upload photo: $error');
    }
  }
}
