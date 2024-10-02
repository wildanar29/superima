import 'package:mobile_rsi/features/auth/domain/repositories/auth_repository.dart';

class GetMedicalNoByNoKK {
  final AuthRepository repository;

  GetMedicalNoByNoKK(this.repository);

  Future<Map<String, String>?> execute(String noKK) {
    return repository.getMedicalNoByNoKK(noKK);
  }
}

