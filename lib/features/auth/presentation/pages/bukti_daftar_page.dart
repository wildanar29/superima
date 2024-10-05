import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class BuktiDaftarPage extends StatefulWidget {
  final Map<String, dynamic> patientData;

  BuktiDaftarPage({required this.patientData});

  @override
  _BuktiDaftarPageState createState() => _BuktiDaftarPageState();
}

class _BuktiDaftarPageState extends State<BuktiDaftarPage> {
  late Future<List<dynamic>> registrationHistory;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  @override
  void initState() {
    super.initState();
    String medicalNo = widget.patientData['MedicalNo'];
    registrationHistory = fetchRegistrationHistory(medicalNo);
  }

  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        if (isStartDate) {
          selectedStartDate = pickedDate;
        } else {
          selectedEndDate = pickedDate;
        }
      });
    }
  }

  // Fungsi untuk mengambil riwayat pendaftaran menggunakan API
  Future<List<dynamic>> fetchRegistrationHistory(String medicalNo) async {
    String url =
        'https://avi.rsimmanuel.net/test/WebService/MobileWS2.asmx/PatientRegistrationHistory?AccessKey=AvcMblPat&MedicalNo=$medicalNo&ServiceUnitID=&ParamedicID=&DateStart=&DateEnd=';

    // Menambahkan tanggal awal dan akhir jika dipilih
    if (selectedEndDate != null && selectedStartDate != null) {
      DateTime newSelectedEndDate = selectedEndDate!;
      DateTime newSelectedStartDate = selectedStartDate!;

      // print(DateFormat('yyyy-MM-dd').format(newSelectedEndDate));
      String newStartDate = DateFormat('yyyy-MM-dd').format(newSelectedStartDate);
      String newEndDate = DateFormat('yyyy-MM-dd').format(newSelectedEndDate);
      url = 'https://avi.rsimmanuel.net/test/WebService/MobileWS2.asmx/PatientRegistrationHistory?AccessKey=AvcMblPat&MedicalNo=$medicalNo&ServiceUnitID=&ParamedicID=&DateStart=$newStartDate&DateEnd=$newEndDate';
    }

    final response = await http.get(Uri.parse(url));
    print(response.body);
    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      final List<dynamic> registrationsData = decodedJson['data'];
      return registrationsData;
    } else {
      throw Exception('Failed to load registration history');
    }
  }

  // Fungsi untuk melakukan pencarian dengan tanggal
  void _searchWithDates() {
    String medicalNo = widget.patientData['MedicalNo'];
    setState(() {
      registrationHistory = fetchRegistrationHistory(medicalNo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Berobat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Riwayat Berobat untuk ${widget.patientData['FirstName']} ${widget.patientData['LastName']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Tanggal Awal
            Row(
              children: [
                Text("Tanggal Awal: "),
                Text(selectedStartDate != null
                    ? "${selectedStartDate!.toLocal()}".split(' ')[0]
                    : "Belum dipilih"),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, true),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Tanggal Akhir
            Row(
              children: [
                Text("Tanggal Akhir: "),
                Text(selectedEndDate != null
                    ? "${selectedEndDate!.toLocal()}".split(' ')[0]
                    : "Belum dipilih"),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, false),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Tombol Cari
            ElevatedButton(
              onPressed: _searchWithDates,
              child: Text('Cari'),
            ),

            // Menampilkan data riwayat pendaftaran setelah diambil dari API
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: registrationHistory,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final registration = snapshot.data![index];
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text('Nomor Registrasi: ${registration['RegistrationNo']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tanggal: ${registration['RegistrationDate_yMdHms']}'),
                                Text('Waktu: ${registration['RegistrationTime']}'),
                                Text('Dokter: ${registration['ParamedicName'] ?? 'Tidak ada'}'),
                                Text('Unit: ${registration['ServiceUnitName'] ?? 'Tidak ada'}'),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('Tidak ada riwayat berobat yang ditemukan.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
