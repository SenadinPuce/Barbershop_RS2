import 'package:barbershop_admin/models/brand.dart';
import 'package:barbershop_admin/models/product.dart';

import 'base_provider.dart';

class ProductProvider extends BaseProvider<Product> {
  ProductProvider() : super("Products");

  @override
  fromJson(item) {
    // TODO: implement fromJson
    return Product.fromJson(item);
  }

}
