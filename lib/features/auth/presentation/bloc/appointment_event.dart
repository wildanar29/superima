abstract class AppointmentEvent {}

class GetAppointmentsEvent extends AppointmentEvent {
  final String medicalNo;

  GetAppointmentsEvent(this.medicalNo);
}