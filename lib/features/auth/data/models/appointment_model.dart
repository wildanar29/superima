import '../../domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  AppointmentModel({
    required String appointmentNo,
    required String appointmentDate,
    required String status,
    required String paramedicName,
    required String appointmentTime,
    required String appointmentQue,
    required String serviceUnitName,
  }) : super(appointmentNo: appointmentNo, appointmentDate: appointmentDate, status: status,paramedicName: paramedicName, appointmentTime: appointmentTime, appointmentQue: appointmentQue,serviceUnitName: serviceUnitName);

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      appointmentNo: json['AppointmentNo'],
      appointmentDate: json['AppointmentDate_yMdHms'],
      status: json['AppointmentStatusName'],
      paramedicName: json['ParamedicName'],
      appointmentTime: json['AppointmentTime'],
      appointmentQue: json['AppointmentQue'],
      serviceUnitName: json['ServiceUnitName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AppointmentNo': appointmentNo,
      'AppointmentDate': appointmentDate,
      'Status': status,
      'paramedicName': paramedicName,
      'appointmentTime': appointmentTime,
      'appointmentQue': appointmentQue,
      'serviceUnitName': serviceUnitName,
    };
  }
}
