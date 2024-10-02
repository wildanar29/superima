class Patient {
  final String? patientID;
  final String? medicalNo;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final DateTime? dateOfBirth;
  final String? streetName;
  final String? district;
  final String? city;
  final String? county;
  final String? state;
  final String? zipCode;
  final String? phoneNo;
  final String? mobilePhoneNo;
  final String? email;
  final String? ssn;
  final String? guarantorID;
  final String? birthPlace;
  final String? sex;
  final String? SRReligion;
  final String? SRReligionName;
  final String? SREducation;
  final String? SREducationName;
  final String? SROccupation;
  final String? SROccupationName;
  final String? SRMaritalStatus;
  final String? SRMaritalStatusName;
  final String? SRTitle;
  final String? SRTitleName;
  final String? DateOfBirth_yMdHms;

  Patient({
    this.patientID,
    this.medicalNo,
    this.firstName,
    this.middleName, // Nullable field
    this.lastName, // Nullable field
    this.dateOfBirth,
    this.streetName,
    this.district, // Nullable field
    this.city, // Nullable field
    this.county, // Nullable field
    this.state, // Nullable field
    this.zipCode, // Nullable field
    this.phoneNo, // Nullable field
    this.mobilePhoneNo, // Nullable field
    this.email, // Nullable field
    this.ssn,
    this.guarantorID,
    this.birthPlace,
    this.sex,
    this.SRReligion,
    this.SRReligionName,
    this.SREducation,
    this.SREducationName,
    this.SROccupation,
    this.SROccupationName,
    this.SRMaritalStatus,
    this.SRMaritalStatusName,
    this.SRTitle,
    this.SRTitleName,
    this.DateOfBirth_yMdHms,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      patientID: json['PatientID'] as String,
      medicalNo: json['MedicalNo'],
      firstName: json['FirstName'],
      middleName: json['MiddleName'],
      lastName: json['LastName'],
      dateOfBirth: DateTime.parse(json['DateOfBirth_yMdHms']),
      streetName: json['StreetName'],
      district: json['District'],
      city: json['City'],
      county: json['County'],
      state: json['State'],
      zipCode: json['ZipCode'],
      phoneNo: json['PhoneNo'],
      mobilePhoneNo: json['MobilePhoneNo'],
      email: json['Email'],
      ssn: json['Ssn'],
      guarantorID: json['GuarantorID'],
      birthPlace: json['BirthPlace'],
      sex: json['Sex'],
      SRReligion: json['SRReligion'],
      SRReligionName: json['SRReligionName'],
      SREducation: json['SREducation'],
      SREducationName: json['SREducationName'],
      SROccupation: json['SROccupation'],
      SROccupationName: json['SROccupationName'],
      SRMaritalStatus:json['SRMaritalStatus'],
      SRMaritalStatusName:json['SRMaritalStatusName'],
      SRTitle: json['SRTitle'],
      SRTitleName: json['SRTitleName'],
      DateOfBirth_yMdHms: json['DateOfBirth_yMdHms'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PatientID': patientID,
      'MedicalNo': medicalNo,
      'FirstName': firstName,
      'MiddleName': middleName,
      'LastName': lastName,
      'DateOfBirth_yMdHms': DateOfBirth_yMdHms,
      'StreetName': streetName,
      'District': district,
      'City': city,
      'County': county,
      'State': state,
      'ZipCode': zipCode,
      'PhoneNo': phoneNo,
      'MobilePhoneNo': mobilePhoneNo,
      'Email': email,
      'Ssn': ssn,
      'GuarantorID': guarantorID,
      'BirthPlace': birthPlace,
      'Sex': sex,
      'SRReligion': SRReligion,
      'SRReligionName': SRReligionName,
      'SREducation': SREducation.toString(),
      'SREducationName': SREducationName,
      'SROccupation': SROccupation,
      'SROccupationName': SROccupationName,
      'SRMaritalStatus' : SRMaritalStatus,
      'SRMaritalStatusName':SRMaritalStatusName,
      'SRTitle': SRTitle,
      'SRTitleName': SRTitleName,
    };
  }
}
