import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/get_patient_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final GetPatientUsecase getPatientUsecase;

  AuthBloc({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.getPatientUsecase,

  }) : super(AuthInitial()) {
    // Registering the event handler for LoginEvent
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUseCase.execute(event.nikOrMedicalNo, event.password);
      if (result != null) {
        final medicalNo = result;
        emit(AuthSuccess(medicalNo));
      } else {
        emit(LoginFailure('Login gagal. Pastikan NIK atau No.RM dan Password benar.'));
      }
    });

    // Registering the event handler for SignupEvent
    on<SignupEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await signupUseCase.execute(event.user);
      if (result) {
        emit(SignupSuccess());
      } else {
        emit(SignupFailure('No Rekam Medik tidak ditemukan.'));
      }
    });

    on<GetPatientEvent>((event, emit) async {
      emit(AuthLoading());
      final patient = await getPatientUsecase.execute(event.medicalNo);

      if (patient != null) {
        emit(GetPatientSuccess(patient)); // Menggunakan state khusus untuk data pasien
      } else {
        emit(GetPatientFailure('Data pasien tidak ditemukan.'));
      }
    });
    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUseCase.logout();
      if (result) {
        emit(AuthLoggedOut());
      } else {
        emit(AuthFailure('Logout gagal.'));
      }
    });

  }
}
