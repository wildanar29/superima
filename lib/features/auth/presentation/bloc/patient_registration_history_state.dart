import '../../domain/entities/patient_registration_history.dart';

abstract class PatientRegistrationHistoryState {}

class PatientRegistrationHistoryInitial extends PatientRegistrationHistoryState {}

class PatientRegistrationHistoryLoading extends PatientRegistrationHistoryState {}

class PatientRegistrationHistoryLoaded extends PatientRegistrationHistoryState {
  final List<PatientRegistrationHistory> history;

  PatientRegistrationHistoryLoaded(this.history);
}

class PatientRegistrationHistoryError extends PatientRegistrationHistoryState {
  final String message;

  PatientRegistrationHistoryError(this.message);
}
