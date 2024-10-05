import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_patient_registration_history_usecase.dart';
import 'patient_registration_history_event.dart';
import 'patient_registration_history_state.dart';

class PatientRegistrationHistoryBloc extends Bloc<PatientRegistrationHistoryEvent, PatientRegistrationHistoryState> {
  final GetPatientRegistrationHistoryUseCase getPatientRegistrationHistoryUseCase;

  PatientRegistrationHistoryBloc(this.getPatientRegistrationHistoryUseCase) : super(PatientRegistrationHistoryInitial()) {
    on<GetPatientRegistrationHistoryEvent>((event, emit) async {
      try {
        emit(PatientRegistrationHistoryLoading());
        final history = await getPatientRegistrationHistoryUseCase.execute(event.medicalNo);
        emit(PatientRegistrationHistoryLoaded(history));
      } catch (e) {
        emit(PatientRegistrationHistoryError('Failed to fetch patient registration history'));
      }
    });
  }
}
