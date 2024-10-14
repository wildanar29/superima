import '../../domain/entities/appointment_create.dart';
import '../../../../core/network/api_service.dart';
import '../../domain/repositories/appointment_repository.dart';
import 'dart:convert';
import '../../domain/entities/appointment.dart';
import '../models/appointment_model.dart';
import 'package:http/http.dart' as http;

class AppointmentRepositoryImpl implements AppointmentRepository {
  final ApiService apiService;
  final String _baseUrl = 'https://avi.rsimmanuel.net/test/WebService/V1_1/AppointmentWS.asmx';

  AppointmentRepositoryImpl(this.apiService);

  @override
  Future<String> createAppointment(AppointmentRequest appointmentModel) async {
    print(appointmentModel.toJson());
    final response = await apiService.post(
      'https://avi.rsimmanuel.net/test/WebService/V1_1/AppointmentWS.asmx/AppointmentCreate',
      appointmentModel.toJson(),
    );
    String validJsonPart = (response.body).split('{"d":null}').first;
    Map<String, dynamic> responseBody = json.decode(validJsonPart);
    print(responseBody);
    if (responseBody['errorCode'] == 201) {
      print('masuknya ke eror');
      return responseBody['errorCode'];
    } else {
      String jsonString = json.encode(responseBody);
      return jsonString;
    }
  }
  @override
  Future<List<Appointment>> getAppointmentsByMedicalNo(String medicalNo) async {
    final String url = '$_baseUrl/AppointmentGetListByMedicalNo?AccessKey=AvcMblPat&MedicalNo=$medicalNo';

    try {
      final response = await http.get(Uri.parse(url));

      // Cetak status code untuk melihat apakah ada masalah di server
      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Cetak respons mentah dari server untuk mengetahui masalah
        print('Raw response: ${response.body}');

        final decodedJson = json.decode(response.body);

        // Pastikan bahwa 'data' ada dan tidak null
        if (decodedJson.containsKey('data') && decodedJson['data'] != null) {
          final List<dynamic> appointmentsData = decodedJson['data'];

          // Cetak appointmentsData untuk memastikan data yang didapat sesuai harapan
          print('Appointments Data: $appointmentsData');

          // Periksa apakah appointmentsData kosong
          if (appointmentsData.isEmpty) {
            print('Data janji temu kosong.');
            throw Exception('Data janji temu kosong.');
          }

          // Coba konversi appointmentsData ke model AppointmentModel
          try {
            return appointmentsData.map((json) => AppointmentModel.fromJson(json)).toList();
          } catch (e) {
            print('Error converting JSON to AppointmentModel: $e');
            throw Exception('Gagal mengonversi janji temu dari JSON');
          }
        } else {
          // Jika 'data' tidak ada atau null, lempar error
          print('Data janji temu tidak ditemukan dalam respons.');
          throw Exception('Data janji temu tidak ditemukan dalam respons.');
        }
      } else {
        // Lempar error jika status code tidak 200
        print('Failed to load appointments. Status code: ${response.statusCode}');
        throw Exception('Failed to load appointments. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Tangkap error yang mungkin terjadi saat mengambil data dari server
      print('Error fetching appointments: $e');
      throw Exception('Error fetching appointments: $e');
    }
  }
}
