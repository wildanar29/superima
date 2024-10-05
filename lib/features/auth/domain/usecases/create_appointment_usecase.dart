// import '../repositories/appointment_repository_impl.dart';
import '../../data/repositories/appointment_repository_impl.dart';
import '../../domain/entities/appointment_create.dart';
import '../repositories/appointment_repository.dart';

class CreateAppointmentUseCase {
  final AppointmentRepository repository;

  CreateAppointmentUseCase(this.repository);

  Future<String> execute(AppointmentRequest appointmentRequest) async {
    // Kembalikan respons dari repository
    return await repository.createAppointment(appointmentRequest);
  }
}

