import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<String?> execute(String nikOrMedicalNo, String password) async {
    return await repository.login(nikOrMedicalNo, password);
  }
  Future<bool> logout() {
    return repository.logout();
  }
}
