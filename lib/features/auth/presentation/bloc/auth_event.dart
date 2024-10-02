import '../../domain/entities/user.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String nikOrMedicalNo;
  final String password;

  LoginEvent(this.nikOrMedicalNo, this.password);
}

class SignupEvent extends AuthEvent {
  final User user;

  SignupEvent(this.user);
}

class GetPatientEvent extends AuthEvent {
  final String medicalNo;

  // Constructor initialization was missing the 'this' keyword
  GetPatientEvent(this.medicalNo);
}

class LogoutEvent extends AuthEvent {}
