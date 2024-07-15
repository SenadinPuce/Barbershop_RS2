import 'package:barbershop_mobile/models/fit_pasos.dart';

import 'base_provider.dart';

class FITPasosProvider extends BaseProvider<FITPasos> {
  FITPasosProvider() : super("FITPasos");

  @override FITPasos fromJson(item) {
    return FITPasos.fromJson(item);
  }
}
