import '../../domain/entities/patient_registration_history.dart';

class PatientRegistrationHistoryModel extends PatientRegistrationHistory {
  PatientRegistrationHistoryModel({
    required String registrationNo,
    required String registrationType,
    required String registrationDate,
    required String registrationTime,
    String? paramedicName,
    String? serviceUnitName,
    String? dischargeDate,
  }) : super(
    registrationNo: registrationNo,
    registrationType: registrationType,
    registrationDate: registrationDate,
    registrationTime: registrationTime,
    paramedicName: paramedicName,
    serviceUnitName: serviceUnitName,
    dischargeDate: dischargeDate,
  );

  factory PatientRegistrationHistoryModel.fromJson(Map<String, dynamic> json) {
    return PatientRegistrationHistoryModel(
      registrationNo: json['RegistrationNo'],
      registrationType: json['SRRegistrationType'],
      registrationDate: json['RegistrationDate_yMdHms'],
      registrationTime: json['RegistrationTime'],
      paramedicName: json['ParamedicName'],
      serviceUnitName: json['ServiceUnitName'],
      dischargeDate: json['DischargeDate_yMdHms'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RegistrationNo': registrationNo,
      'SRRegistrationType': registrationType,
      'RegistrationDate_yMdHms': registrationDate,
      'RegistrationTime': registrationTime,
      'ParamedicName': paramedicName,
      'ServiceUnitName': serviceUnitName,
      'DischargeDate_yMdHms': dischargeDate,
    };
  }
}
