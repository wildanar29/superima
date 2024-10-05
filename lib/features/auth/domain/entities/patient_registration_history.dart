class PatientRegistrationHistory {
  final String registrationNo;
  final String registrationType;
  final String registrationDate;
  final String registrationTime;
  final String? paramedicName;
  final String? serviceUnitName;
  final String? dischargeDate;

  PatientRegistrationHistory({
    required this.registrationNo,
    required this.registrationType,
    required this.registrationDate,
    required this.registrationTime,
    this.paramedicName,
    this.serviceUnitName,
    this.dischargeDate,
  });
}
