import '../models/brand.dart';
import 'base_provider.dart';

class ProductBrandProvider extends BaseProvider<ProductBrand> {
  ProductBrandProvider() : super("ProductBrands");

  @override
  fromJson(item) {
    // TODO: implement fromJson
    return ProductBrand.fromJson(item);
  }

}
