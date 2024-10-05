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
        title: Text('Cek Ketersediaan Kamar'),
      ),
      body: bedAvailabilityList.isNotEmpty
          ? ListView.builder(
        itemCount: bedAvailabilityList.length,
        itemBuilder: (context, index) {
          final bedData = bedAvailabilityList[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              title: Text('Kelas: ${bedData['ClassName']}'),
              subtitle: Text('Jumlah Tersedia: ${bedData['JumlahTersedia']}'),
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
