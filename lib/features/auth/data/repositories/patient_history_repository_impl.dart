import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/patient_registration_history.dart';
import '../../domain/repositories/patient_history_repository.dart';
import '../models/patient_registration_history_model.dart';

class PatientRepositoryImpl implements PatientRepository {
  final String _baseUrl = 'https://avi.rsimmanuel.net/test/WebService/MobileWS2.asmx';

  @override
  Future<List<PatientRegistrationHistory>> getPatientRegistrationHistory(String medicalNo) async {
    final String url = '$_baseUrl/PatientRegistrationHistory?AccessKey=AvcMblPat&MedicalNo=$medicalNo&ServiceUnitID=&ParamedicID=&DateStart=&DateEnd=';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      final List<dynamic> registrationsData = decodedJson['data'];

      return registrationsData.map((json) => PatientRegistrationHistoryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load patient registration history');
    }
  }
}
