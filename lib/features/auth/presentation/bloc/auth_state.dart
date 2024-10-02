import '../../domain/entities/patient.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String medicalNo;

  AuthSuccess(this.medicalNo); // Tambahkan medicalNo sebagai parameter
}

class LoginFailure extends AuthState {
  final String message;

  LoginFailure(this.message);
}
class SignupSuccess extends AuthState {

}
class SignupFailure extends AuthState {
  final String message;

  SignupFailure(this.message);
}
class GetPatientFailure extends AuthState {
  final String message;

  GetPatientFailure(this.message);
}

class GetPatientSuccess extends AuthState {
  final Patient patient;

  GetPatientSuccess(this.patient);
}

// Tambahkan state untuk menandakan user sudah logout
class AuthLoggedOut extends AuthState {}

// Tambahkan state untuk menandakan kegagalan umum
class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}


