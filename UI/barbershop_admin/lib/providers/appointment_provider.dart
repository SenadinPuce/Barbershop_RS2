import '../models/appointment.dart';
import 'base_provider.dart';

class AppointmentProvider extends BaseProvider<Appointment> {
  AppointmentProvider() : super("Appointments");

  @override
  Appointment fromJson(item) {
    return Appointment.fromJson(item);
  }

  Future<Appointment> updateAppointmentStatus(
      int appointmentId, String status) async {
    return await update(appointmentId, status, 'update-status');
  }
}
