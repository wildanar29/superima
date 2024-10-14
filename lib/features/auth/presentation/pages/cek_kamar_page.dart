import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CekKamarPage extends StatefulWidget {
  @override
  _CekKamarPageState createState() => _CekKamarPageState();
}

class _CekKamarPageState extends State<CekKamarPage> {
  List<dynamic> bedAvailabilityList = [];

  // Fungsi untuk mengambil data ketersediaan kamar dari API
  Future<void> fetchBedAvailability() async {
    final String url =
        'https://avi.rsimmanuel.net/test/WebService/MobileWS2.asmx/BedAvailability?AccessKey=AvcMblPat';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        setState(() {
          bedAvailabilityList = decodedJson['data'];
        });
      } else {
        throw Exception('Failed to load bed availability');
      }
    } catch (e) {
      print('Error fetching bed availability: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Panggil fetchBedAvailability ketika halaman dimulai
    fetchBedAvailability();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Untuk menengahkan teks di AppBar
        title: Text(
          'Cek Kamar',
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
      body: bedAvailabilityList.isNotEmpty
          ? ListView.builder(
        itemCount: bedAvailabilityList.length,
        itemBuilder: (context, index) {
          final bedData = bedAvailabilityList[index];
          return Center( // Posisikan card di tengah
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Container(
                width: 300, // Menentukan lebar card, sesuaikan sesuai kebutuhan
                color: Colors.blue[50], // Latar belakang biru muda untuk seluruh container
                padding: EdgeInsets.all(8), // Padding di dalam container
                child: Row(
                  children: [
                    // Gambar di sebelah kiri
                    Image.asset(
                      'assets/bed.png',
                      width: 50, // Sesuaikan ukuran gambar
                      height: 50,
                    ),
                    SizedBox(width: 16), // Memberi jarak antara gambar dan teks
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Teks rata kiri
                        children: [
                          Text(
                            'Kelas: ${bedData['ClassName']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16, // Sesuaikan ukuran teks
                            ),
                          ),
                          SizedBox(height: 8), // Jarak antar teks
                          Text(
                            'Jumlah Tersedia: ${bedData['JumlahTersedia']}',
                            style: TextStyle(fontSize: 14), // Sesuaikan ukuran teks
                          ),
                        ],
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
        child: CircularProgressIndicator(), // Tampilkan loading jika data belum ada
      ),
    );
  }
}
