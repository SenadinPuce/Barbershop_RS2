import 'base_provider.dart';
import '../models/appointment.dart';

class AppointmentProvider extends BaseProvider<Appointment> {
  AppointmentProvider() : super("Appointments");

  @override
  Appointment fromJson(item) {
    return Appointment.fromJson(item);
  }
}
