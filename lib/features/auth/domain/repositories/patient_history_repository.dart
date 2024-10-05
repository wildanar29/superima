import '../../domain/entities/patient_registration_history.dart';

abstract class PatientRepository {
  Future<List<PatientRegistrationHistory>> getPatientRegistrationHistory(String medicalNo);
}
