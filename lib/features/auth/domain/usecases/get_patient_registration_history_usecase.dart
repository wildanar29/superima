import '../entities/patient_registration_history.dart';
import '../repositories/patient_history_repository.dart';

class GetPatientRegistrationHistoryUseCase {
  final PatientRepository repository;

  GetPatientRegistrationHistoryUseCase(this.repository);

  Future<List<PatientRegistrationHistory>> execute(String medicalNo) {
    return repository.getPatientRegistrationHistory(medicalNo);
  }
}
