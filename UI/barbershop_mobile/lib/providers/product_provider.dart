import 'package:barbershop_mobile/models/product.dart';
import 'package:barbershop_mobile/providers/base_provider.dart';

class ProductProvider extends BaseProvider<Product> {
  ProductProvider() : super("Products");

  @override
  fromJson(item) {
    return Product.fromJson(item);
  }
}
