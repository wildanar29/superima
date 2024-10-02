import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/patient.dart'; // Pastikan sudah diimport
import '../../domain/repositories/patient_repository.dart';

class PatientRepositoryImpl implements PatientRepository {
  final String getPatientUrl = 'http://10.10.10.5/test3/WebService/V1_1/AppointmentWS.asmx/PatientGetOneByMedicalNo?AccessKey=AvcMblPat&MedicalNo=';

  @override
  Future<Patient?> getPatient(String medicalNo) async {
    // Gunakan http.get karena hanya mendapatkan data
    final response = await http.get(
      Uri.parse('$getPatientUrl$medicalNo'),
      // headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Decode JSON dan buat objek Patient dari respons
      final Map<String, dynamic> body = jsonDecode(response.body);
      // print(body);

      // Contoh: Memeriksa apakah respons memiliki status error
      if (body['status'] == 'error') {
        return null;
      } else {
        final data = body['data'];
        // print('disini');
        // print(data);
        // print('disini');
        // Mapkan response ke model Patient
        return Patient.fromJson(data);
      }
    } else {
      // Jika ada masalah dengan HTTP request
      throw Exception('Failed to load patient data');
    }
  }
}
