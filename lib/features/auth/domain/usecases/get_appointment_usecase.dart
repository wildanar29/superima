import '../entities/appointment.dart';
import '../repositories/appointment_repository.dart';

class GetAppointmentsUseCase {
  final AppointmentRepository appointmentRepository;

  GetAppointmentsUseCase(this.appointmentRepository);

  Future<List<Appointment>> execute(String medicalNo) async {
    return await appointmentRepository.getAppointmentsByMedicalNo(medicalNo);
  }
}
