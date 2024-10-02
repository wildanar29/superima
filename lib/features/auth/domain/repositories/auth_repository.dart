// lib/features/auth/domain/repositories/auth_repository.dart
import '../entities/user.dart';

abstract class AuthRepository {
  Future<String?> login(String nikOrMedicalNo, String password);
  Future<String?> getNoKKByMedicalNo(String medicalNo);
  Future<Map<String, String>?> getMedicalNoByNoKK(String noKK);
  Future<bool> signup(User user);
  Future<bool> logout();

}

