import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final String loginUrl = 'http://10.200.200.20:8080/login';
  final String signupUrl = 'http://10.200.200.20:8080/register';
  final String checkMedicalNoUrl = 'http://10.10.10.5/test3/WebService/V1_1/AppointmentWS.asmx/PatientGetOneByMedicalNo?AccessKey=AvcMblPat&MedicalNo=';
  final String logoutUrl = 'http://10.200.200.20:8080/logout';
  final String noKKUrl = 'http://10.200.200.20:8080/user/nokk';
  final String medicalNoUrl = 'http://10.200.200.20:8080//get-medicalno';

  @override
  Future<String?> login(String nikOrMedicalNo, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nikOrMedicalNo': nikOrMedicalNo, 'password': password}),
      );
      if (response.statusCode == 200) {
        // Ambil instance Hive box
        var box = Hive.box('myBox');
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        // print(responseBody['user']['medicalNo']);
        if (responseBody.containsKey('token')) {
          // Menyimpan JWT token ke Hive
          await box.put('jwt_token', responseBody['token']);
          return responseBody['user']['medicalNo'];
        } else {
          print('Token tidak ditemukan dalam respons.');
          return null;
        }
      } else {
        print('Login gagal dengan status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error saat login: $e');
      return null;
    }
  }

  @override
  Future<bool> signup(User user) async {
    final checkResponse = await http.get(Uri.parse(checkMedicalNoUrl + user.medicalNo));
    Map<String, dynamic> status = jsonDecode(checkResponse.body);
    if (status['errorCode'] == '200') {
      print('error pada errorCode');
      // print(status);
      return false;
    }
    else {
      final response = await http.post(
        Uri.parse(signupUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );
      // print('ini responssssssssssss');
      final enBody = response.body;
      // print(enBody);
      Map<String, dynamic> body = jsonDecode(enBody);

      if (body['status'] == "error") {
        return false;
      } else {
        return true;
      }
    }
  }
  @override
  Future<bool> logout() async {
    try {
      // Mengambil JWT token dari Hive
      var box = Hive.box('myBox');
      var token = box.get('jwt_token');

      // Melakukan request POST ke API logout dengan token
      final response = await http.post(
        Uri.parse(logoutUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Sertakan JWT di header
        },
      );

      // Mencetak response body untuk debugging
      // print(response.body);

      if (response.statusCode == 200) {
        // Menghapus token dari Hive
        await box.delete('jwt_token');
        return true;
      } else {
        print('Logout gagal dengan status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error saat logout: $e');
      return false;
    }
  }
  @override
  Future<String?> getNoKKByMedicalNo(String medicalNo) async {
    try {
      // Kirim permintaan POST ke server untuk mendapatkan noKK berdasarkan medicalNo
      final response = await http.post(
        Uri.parse(noKKUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'medicalNo': medicalNo}),
      );

      if (response.statusCode == 200) {
        // Memparsing response body
        Map<String, dynamic> responseBody = jsonDecode(response.body);

        // Memeriksa apakah respons berhasil dan mengandung noKK
        if (responseBody['status'] == 'success' && responseBody.containsKey('noKK')) {
          return responseBody['noKK'];
        } else {
          print('NoKK tidak ditemukan atau respons gagal.');
          return null;
        }
      } else {
        print('Gagal mengambil noKK, status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error saat mengambil noKK: $e');
      return null;
    }
  }
  @override
  Future<Map<String, String>?> getMedicalNoByNoKK(String noKK) async {
    try {
      // Kirim permintaan POST ke server untuk mendapatkan medicalNo berdasarkan noKK
      final response = await http.post(
        Uri.parse(medicalNoUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'noKK': noKK}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);

        // Memeriksa apakah respons berhasil dan mengandung medicalNos dan patient names
        if (responseBody['status'] == 'success' && responseBody.containsKey('patients')) {
          // Memastikan bahwa 'patients' adalah map yang mengandung medicalNo sebagai key dan name sebagai value
          Map<String, dynamic> patientsMap = responseBody['patients'];

          // Mengonversi map menjadi Map<String, String> untuk mengembalikan hasil
          return Map<String, String>.from(patientsMap);
        } else {
          print('MedicalNo tidak ditemukan atau respons gagal.');
          return null;
        }
      } else {
        print('Gagal mengambil medicalNo, status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error saat mengambil medicalNo: $e');
      return null;
    }
  }

}
