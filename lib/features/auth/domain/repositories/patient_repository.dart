import '../entities/patient.dart';
abstract class PatientRepository {
  Future<Patient?> getPatient(String medicalNo);
}
