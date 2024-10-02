import '../entities/paramedic.dart';

abstract class ParamedicRepository {
  Future<List<Paramedic>> getAllParamedics();
}
