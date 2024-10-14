import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/paramedic.dart';
import '../../domain/repositories/paramedic_repository.dart';

class ParamedicRepositoryImpl implements ParamedicRepository {
  final String baseUrl = "https://app.rsimmanuel.net/getAllParamedicIDnNameNonBPJSnMixed";

  @override
  Future<List<Paramedic>> getAllParamedics() async {
    final response = await http.get(Uri.parse('${baseUrl}'));
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> paramedicList = json.decode(response.body);
      print(paramedicList[0]);
      return paramedicList.map((paramedic) => Paramedic.fromJson(paramedic)).toList();
    } else {
      throw Exception('Failed to load paramedics');
    }
  }
  Future<List<Paramedic>> getDoctorsByPoli(String poliId) async {
    // Panggil API atau data lokal untuk mengambil daftar dokter berdasarkan poliId
    // Contoh implementasi API call
    final response = await http.get(Uri.parse('https://app.rsimmanuel.net/getParamedicByServiceUnit?serviceunitid=$poliId'));
    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Paramedic.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load doctors');
    }
  }
}
