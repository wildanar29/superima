import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_appointment_usecase.dart';
import '../../domain/entities/appointment_create.dart';

class AppointmentEvent {}

class AppointmentCreateEvent extends AppointmentEvent {
  final AppointmentRequest appointmentRequest;

  AppointmentCreateEvent(this.appointmentRequest);
}

class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentSuccess extends AppointmentState {}

class AppointmentFailure extends AppointmentState {}

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final CreateAppointmentUseCase createAppointmentUseCase;

  AppointmentBloc(this.createAppointmentUseCase) : super(AppointmentInitial());

  @override
  Stream<AppointmentState> mapEventToState(AppointmentEvent event) async* {
    if (event is AppointmentCreateEvent) {
      yield AppointmentLoading();

      final success = await createAppointmentUseCase.execute(event.appointmentRequest);

      if (success != null) {
        yield AppointmentSuccess();
      } else {
        yield AppointmentFailure();
      }
    }
  }
}
