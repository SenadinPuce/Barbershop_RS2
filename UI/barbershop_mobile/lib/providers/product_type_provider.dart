import '../models/type.dart';
import 'base_provider.dart';

class ProductTypeProvider extends BaseProvider<ProductType> {
  ProductTypeProvider() : super("ProductTypes");

  @override
  fromJson(item) {
    // TODO: implement fromJson
    return ProductType.fromJson(item);
  }

}