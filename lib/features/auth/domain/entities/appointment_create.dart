class AppointmentRequest {
  final String serviceUnitID;
  final String paramedicID;
  final String appointmentDate;
  final String appointmentTime;
  final String patientID;
  final String firstName;
  final String middleName;
  final String lastName;
  final String dateOfBirth;
  final String streetName;
  final String district;
  final String county;
  final String city;
  final String state;
  final String zipCode;
  final String phoneNo;
  final String email;
  final String guarantorID;
  final String notes;
  final String birthPlace;
  final String sex;
  final String ssn;
  final String mobilePhoneNo;

  AppointmentRequest({
    required this.serviceUnitID,
    required this.paramedicID,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.patientID,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.dateOfBirth,
    required this.streetName,
    required this.district,
    required this.county,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.phoneNo,
    required this.email,
    required this.guarantorID,
    required this.notes,
    required this.birthPlace,
    required this.sex,
    required this.ssn,
    required this.mobilePhoneNo,
  });

  Map<String, dynamic> toJson() {
    return {
      'AccessKey': 'AvcMblPat',
      'ServiceUnitID': serviceUnitID,
      'ParamedicID': paramedicID,
      'AppointmentDate': appointmentDate,
      'AppointmentTime': appointmentTime,
      'PatientID': patientID,
      'FirstName': firstName,
      'MiddleName': middleName,
      'LastName': lastName,
      'DateOfBirth': dateOfBirth,
      'StreetName': streetName,
      'District': district,
      'County': county,
      'City': city,
      'State': state,
      'ZipCode': zipCode,
      'PhoneNo': phoneNo,
      'Email': email,
      'GuarantorID': guarantorID,
      'Notes': notes,
      'BirthPlace': birthPlace,
      'Sex': sex,
      'Ssn': ssn,
      'MobilePhoneNo': mobilePhoneNo,
    };
  }
}
