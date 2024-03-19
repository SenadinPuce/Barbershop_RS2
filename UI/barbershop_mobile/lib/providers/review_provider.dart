import 'package:barbershop_mobile/models/review.dart';
import 'package:barbershop_mobile/providers/base_provider.dart';

class ReviewProvider extends BaseProvider<Review> {
  ReviewProvider() : super("Reviews");

  @override
  Review fromJson(item) {
    return Review.fromJson(item);
  }
}
