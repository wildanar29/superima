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
        centerTitle: true, // Untuk menengahkan teks di AppBar
        title: Text(
          'Bukti Daftar',
          style: TextStyle(
            fontSize: 24, // Ukuran teks lebih besar
            fontWeight: FontWeight.bold, // Membuat teks tebal
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios), // Menambahkan ikon panah kembali
          iconSize: 35, // Memperbesar ukuran ikon
          onPressed: () {
            Navigator.pop(context); // Aksi kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bukti Daftar ${widget.patientData['FirstName']} ${widget.patientData['LastName']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Tanggal Awal
            Row(
              children: [
                Text(
                  "Tanggal Awal: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Membuat teks menjadi tebal
                    fontSize: 16, // Menambahkan ukuran font (opsional)
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 4), // Padding di dalam border
                  decoration: BoxDecoration(
                    color: Colors.blue[50], // Latar belakang biru muda
                    border: Border.all(
                      color: Colors.blue, // Warna border biru
                      width: 2.0, // Ketebalan border
                    ),
                    borderRadius: BorderRadius.circular(10), // Membuat sudut border melengkung
                  ),
                  child: Text(selectedStartDate != null
                      ? "${selectedStartDate!.toLocal()}".split(' ')[0]
                      : "Belum dipilih"),
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
              children: [
                Text(
                  "Tanggal Akhir: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Membuat teks menjadi tebal
                    fontSize: 16, // Menambahkan ukuran font (opsional)
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 48, vertical: 4), // Padding di dalam border
                  decoration: BoxDecoration(
                    color: Colors.blue[50], // Latar belakang biru muda
                    border: Border.all(
                      color: Colors.blue, // Warna border biru
                      width: 2.0, // Ketebalan border
                    ),
                    borderRadius: BorderRadius.circular(10), // Membuat sudut border melengkung
                  ),
                  child: Text(selectedEndDate != null
                      ? "${selectedEndDate!.toLocal()}".split(' ')[0]
                      : "Belum dipilih"),
                ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Warna background biru
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Membuat tombol lebih lebar dan tinggi
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Membuat sudut tombol melengkung
                ),
                minimumSize: Size(double.infinity, 50), // Membuat tombol memanjang sepanjang lebar layar
              ),
              child: Text(
                'Cari',
                style: TextStyle(
                  fontSize: 20, // Ukuran teks yang lebih besar
                  color: Colors.white, // Warna teks menjadi putih
                  fontWeight: FontWeight.bold, // Membuat teks menjadi tebal
                ),
              ),
            ),

            // Menampilkan data riwayat pendaftaran setelah diambil dari API
            // Expanded untuk menampilkan daftar riwayat berobat
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
                          child: Container(
                            color: Colors.blue[50], // Latar belakang biru muda untuk setiap item
                            child: ListTile(
                              title: Text(
                                'Nomor Registrasi: ${registration['RegistrationNo']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tipe Registrasi: ${registration['SRRegistrationType']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14, // Sesuaikan ukuran teks
                                    ),
                                  ),
                                  Text(
                                    'Tanggal: ${registration['RegistrationDate_yMdHms']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Waktu: ${registration['RegistrationTime']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Dokter: ${registration['ParamedicName'] ?? 'Tidak ada'}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Unit: ${registration['ServiceUnitName'] ?? 'Tidak ada'}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Catatan: ${registration['DischargeNotes'] ?? 'Tidak ada'}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
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
