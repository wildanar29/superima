import '../entities/paramedic.dart';
import '../repositories/paramedic_repository.dart';

class GetAllParamedicsUseCase {
  final ParamedicRepository paramedicRepository;

  GetAllParamedicsUseCase(this.paramedicRepository);

  Future<List<Paramedic>> execute() {
    return paramedicRepository.getAllParamedics();
  }
}
