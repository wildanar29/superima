import 'dart:convert';
import 'package:http/http.dart' as http;

class ParamedicScheduleRepositoryImpl {
  final String baseUrl = 'http://10.10.10.5/test3/WebService/V1_1/AppointmentWS.asmx/ParamedicScheduleDateGetList?AccessKey=AvcMblPat';

  // Mengubah return type menjadi Map agar bisa mengembalikan StartTime1 dan EndTime1
  Future<Map<String, String?>> getParamedicSchedule(
      String dateStart,
      String dateEnd,
      String paramedicID,
      String serviceUnitID,
      ) async {
    final response = await http.get(Uri.parse(
      '$baseUrl&DateStart=$dateStart&DateEnd=$dateEnd&ParamedicID=$paramedicID&ServiceUnitID=$serviceUnitID',
    ));

    if (response.statusCode == 200) {
      // Decode JSON response
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);

      // Cek apakah ada data dalam 'data' key
      if (jsonResponse['data'] != null && jsonResponse['data'].isNotEmpty) {
        final scheduleData = jsonResponse['data'][0];

        // Ambil nilai StartTime1 dan EndTime1
        final String? startTime1 = scheduleData['StartTime1'];
        final String? endTime1 = scheduleData['EndTime1'];

        return {
          'StartTime1': startTime1,
          'EndTime1': endTime1,
        };
      }

      // Jika tidak ada jadwal, kembalikan map dengan nilai null
      return {
        'StartTime1': null,
        'EndTime1': null,
      };
    } else {
      throw Exception('Failed to load paramedic schedules');
    }
  }
}
