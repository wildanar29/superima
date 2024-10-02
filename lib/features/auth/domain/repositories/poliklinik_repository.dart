import '../entities/poliklinik.dart';

abstract class PoliKlinikRepository {
  Future<List<PoliKlinik>> getAllPoliKlinik();
  Future<List<PoliKlinik>> getPoliKlinikByParamedicId(String paramedicId);
}
