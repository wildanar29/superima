abstract class PatientRegistrationHistoryEvent {}

class GetPatientRegistrationHistoryEvent extends PatientRegistrationHistoryEvent {
  final String medicalNo;

  GetPatientRegistrationHistoryEvent(this.medicalNo);
}
