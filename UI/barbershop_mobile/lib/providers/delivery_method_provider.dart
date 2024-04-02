import '../models/delivery_method.dart';
import 'base_provider.dart';

class DeliveryMethodProvider extends BaseProvider<DeliveryMethod> {
  DeliveryMethodProvider() : super("DeliveryMethods");

  @override
  DeliveryMethod fromJson(item) {
    return DeliveryMethod.fromJson(item);
  }
}
