import '../entities/patient.dart';
import '../repositories/patient_repository.dart';

class GetPatientUsecase {
  final PatientRepository repository;

  GetPatientUsecase(this.repository);

  Future<Patient?> execute(String medicalNo) async {
    return await repository.getPatient(medicalNo);
  }
}
