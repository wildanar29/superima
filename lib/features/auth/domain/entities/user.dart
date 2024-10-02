class User {
  final String medicalNo;
  final String phoneNumber;
  final String nik;
  final String password;
  final String email;
  final String noKK;

  User({
    required this.medicalNo,
    required this.phoneNumber,
    required this.nik,
    required this.password,
    required this.email,
    required this.noKK,
  });

  Map<String, dynamic> toJson() {
    return {
      'medicalNo': medicalNo,
      'phoneNumber': phoneNumber,
      'nik': nik,
      'password': password,
      'email': email,
      'noKK': noKK,
    };
  }
}
