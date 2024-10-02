// lib/features/auth/data/models/user_model.dart
import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String medicalNo,
    required String phoneNumber,
    required String nik,
    required String password,
    required String email,
    required String noKK,
  }) : super(medicalNo: medicalNo, phoneNumber: phoneNumber, nik: nik, password: password, email: email,noKK: noKK);

  Map<String, dynamic> toJson() {
    return {
      'medicalNo': medicalNo,
      'phoneNumber': phoneNumber,
      'nik': nik,
      'password': password,
      'email': email,
    };
  }
}
