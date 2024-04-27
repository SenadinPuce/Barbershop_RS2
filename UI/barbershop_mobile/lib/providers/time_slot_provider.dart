import 'package:barbershop_mobile/models/time_slot.dart';
import 'package:barbershop_mobile/providers/base_provider.dart';

class TimeSlotProvider extends BaseProvider<TimeSlot> {
  TimeSlotProvider() : super("TimeSlots");

  @override
  TimeSlot fromJson(item) {
    return TimeSlot.fromJson(item);
  }
}
