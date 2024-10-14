import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/poliklinik.dart';
import '../../domain/repositories/poliklinik_repository.dart';

class PoliKlinikRepositoryImpl implements PoliKlinikRepository {
  final String baseUrl = "https://app.rsimmanuel.net/getAllServiceUnitNonBPJSnMixed";

  @override
  Future<List<PoliKlinik>> getAllPoliKlinik() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> poliList = json.decode(response.body);
      return poliList.map((poli) => PoliKlinik.fromJson(poli)).toList();
    } else {
      throw Exception('Failed to load Poli Klinik');
    }
  }
  @override
  Future<List<PoliKlinik>> getPoliKlinikByParamedicId(String paramedicId) async {
    final response = await http.get(Uri.parse('http://103.165.218.182:8080/getServiceUnitByParamedicID?paramedicid=$paramedicId'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('ini poliiiiii ${jsonResponse}');
      return jsonResponse.map((data) => PoliKlinik.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load Poli Klinik');
    }
  }
}
