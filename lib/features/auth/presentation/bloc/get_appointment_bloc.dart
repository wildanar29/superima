import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_appointment_usecase.dart';
import 'appointment_event.dart';
import 'appointment_state.dart';

class GetAppointmentsBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final GetAppointmentsUseCase getAppointmentsUseCase;

  GetAppointmentsBloc(this.getAppointmentsUseCase) : super(AppointmentInitial()) {
    on<GetAppointmentsEvent>((event, emit) async {
      try {
        emit(AppointmentLoading());
        final appointments = await getAppointmentsUseCase.execute(event.medicalNo);
        emit(AppointmentLoaded(appointments));
      } catch (e) {
        emit(AppointmentError('Failed to fetch appointments'));
      }
    });
  }
}
