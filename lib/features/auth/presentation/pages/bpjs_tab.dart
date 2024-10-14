import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import intl for date formatting

class BPJSTab extends StatefulWidget {
  @override
  _BPJSTabState createState() => _BPJSTabState();
}

class _BPJSTabState extends State<BPJSTab> {
  List<dynamic> paramedicList = [];
  List<dynamic> scheduleList = [];
  DateTime? _startDate;
  DateTime? _endDate;

  // Fungsi untuk mengambil daftar Paramedic dari API
  Future<void> fetchParamedicList() async {
    final String url = 'https://app.rsimmanuel.net/getAllParamedicIDnNameBPJSnMixed';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        setState(() {
          paramedicList = decodedJson;
          printParamedicList(); // Cetak data setelah mengambil dari API
        });
      } else {
        throw Exception('Failed to load paramedics');
      }
    } catch (e) {
      print('Error fetching paramedics: $e');
    }
  }

  // Fungsi untuk mencetak daftar paramedic ke log
  void printParamedicList() {
    for (var paramedic in paramedicList) {
      print('ParamedicID: ${paramedic['paramedicid']}');
    }
  }

  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  // Fungsi untuk mengambil jadwal dokter dari API menggunakan looping pada paramedicList
  Future<void> fetchDoctorSchedule() async {
    if (_startDate == null || _endDate == null || paramedicList.isEmpty) {
      print('Tanggal atau ParamedicID belum diisi');
      return;
    }

    List<dynamic> allSchedules = [];
    for (var paramedic in paramedicList) {
      String paramedicID = paramedic['paramedicid'];
      DateTime newSelectedStartDate = _startDate!;
      DateTime newSelectedEndDate = _endDate!;
      String newStartDate = DateFormat('yyyy-MM-dd').format(newSelectedStartDate);
      String newEndDate = DateFormat('yyyy-MM-dd').format(newSelectedEndDate);
      final String url =
          'https://avi.rsimmanuel.net/test/WebService/V1_1/AppointmentWS.asmx/ParamedicScheduleDateGetList?AccessKey=AvcMblPat&DateStart=$newStartDate&DateEnd=$newEndDate&ParamedicID=$paramedicID&ServiceUnitID=';
      try {
        final response = await http.get(Uri.parse(url));
        // print(response.body);
        if (response.statusCode == 200) {
          final decodedJson = json.decode(response.body);
          if (decodedJson['data'] != null && decodedJson['data'] is List) {
            for (var schedule in decodedJson['data']) {
              // Cek apakah data sudah ada di allSchedules berdasarkan atribut unik seperti 'ParamedicID' dan 'DateStart'
              bool exists = allSchedules.any((existingSchedule) =>
              existingSchedule['ParamedicID'] == schedule['ParamedicID'] &&
                  existingSchedule['DateStart'] == schedule['DateStart']);

              // Jika data belum ada, masukkan ke allSchedules
              if (!exists) {
                allSchedules.add(schedule);
              }
              print(allSchedules);
            }
          }
        } else {
          print('Failed to load doctor schedule for ParamedicID: $paramedicID');
        }
      } catch (e) {
        print('Error fetching doctor schedule for ParamedicID: $paramedicID - $e');
      }
    }
    print(allSchedules);

    // Set state dengan semua jadwal dokter yang berhasil diambil
    setState(() {
      scheduleList = allSchedules;
    });
  }

  @override
  void initState() {
    super.initState();
    // Panggil fetchParamedicList ketika halaman dimulai
    fetchParamedicList();
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan DateFormat untuk menampilkan tanggal yang dipilih dengan benar
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _startDate != null
                      ? '${dateFormatter.format(_startDate!)}'
                      : 'Pilih Tanggal Awal',
                  style: TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, true),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Tanggal Akhir
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _endDate != null
                      ? '${dateFormatter.format(_endDate!)}'
                      : 'Pilih Tanggal Akhir',
                  style: TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, false),
                ),
              ],
            ),

            SizedBox(height: 1),

            // Tombol Cari Berdasarkan Tanggal
            SizedBox(height: 1),
            ElevatedButton(
              onPressed: () {
                // Panggil API untuk mencari jadwal dokter berdasarkan tanggal dan paramedic
                fetchDoctorSchedule();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Latar belakang biru
                padding: EdgeInsets.symmetric(horizontal: 90, vertical: 4), // Ukuran padding di sekitar teks
              ),
              child: Text(
                'Cari Jadwal',
                style: TextStyle(
                  color: Colors.white, // Warna teks menjadi putih
                  fontSize: 16, // Ukuran teks
                  fontWeight: FontWeight.bold, // Membuat teks tebal
                ),
              ),
            ),

            SizedBox(height: 20),

            // Menampilkan data jadwal dokter
            Expanded(
              child: scheduleList.isNotEmpty
                  ? ListView.builder(
                itemCount: scheduleList.length,
                itemBuilder: (context, index) {
                  final schedule = scheduleList[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      color: Colors.blue[50], // Latar belakang biru muda
                      child: ListTile(
                        title: Text(
                          'Paramedic Name: ${schedule['ParamedicName']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // Membuat teks tebal
                            color: Colors.black, // Warna teks hitam
                            fontSize: 17,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal Mulai: ${schedule['StartTime1']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold, // Membuat teks tebal
                                color: Colors.black, // Warna teks hitam
                              ),
                            ),
                            Text(
                              'Tanggal Akhir: ${schedule['EndTime1']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold, // Membuat teks tebal
                                color: Colors.black, // Warna teks hitam
                              ),
                            ),
                            Text(
                              'Unit Layanan: ${schedule['ServiceUnitName']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold, // Membuat teks tebal
                                color: Colors.black, // Warna teks hitam
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
                  : Center(
                child: Text(
                  'Tidak ada jadwal dokter yang ditemukan.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
