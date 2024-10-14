// appointment_state.dart

abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final List<dynamic> appointments; // Sesuaikan dengan tipe data janji temu
  AppointmentLoaded(this.appointments);
}

class AppointmentSuccess extends AppointmentState {}

class AppointmentFailure extends AppointmentState {}

class AppointmentError extends AppointmentState {
  final String message;
  AppointmentError(this.message);
}
