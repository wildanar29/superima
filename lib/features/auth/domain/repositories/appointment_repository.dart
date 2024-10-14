import '../entities/appointment_create.dart';
import '../entities/appointment.dart';
abstract class AppointmentRepository {
  Future<String> createAppointment(AppointmentRequest appointmentRequest);
  Future<List<Appointment>> getAppointmentsByMedicalNo(String medicalNo);
}
