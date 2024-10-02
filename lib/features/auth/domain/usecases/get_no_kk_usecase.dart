// lib/features/peserta/domain/usecases/get_no_kk_usecase.dart
import 'package:mobile_rsi/features/auth/domain/repositories/auth_repository.dart';

class GetNoKKUseCase {
  final AuthRepository repository;

  GetNoKKUseCase(this.repository);

  Future<String?> execute(String medicalNo) {
    return repository.getNoKKByMedicalNo(medicalNo);
  }
}
