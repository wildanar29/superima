import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class KritikSaranPage extends StatelessWidget {
  // Fungsi untuk membuka link Google Forms
  void _launchSurvey() async {
    const url = 'https://forms.gle/wfZLHboqJcVYex1q8'; // URL Google Forms
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication); // Buka link di browser
    } else {
      throw 'Could not launch $url';
    }
  }

  // Fungsi untuk membuka WhatsApp
  void _launchWhatsApp() async {
    const phoneNumber = '08112187773'; // Nomor WhatsApp
    final whatsappUrl = Uri.parse('https://wa.me/$phoneNumber'); // Format URL WhatsApp
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication); // Buka WhatsApp dengan nomor
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kritik & Saran',
          style: TextStyle(
            fontSize: 24, // Ukuran teks lebih besar
            fontWeight: FontWeight.bold, // Membuat teks tebal
          ),
        ),
        centerTitle: true, // Teks di tengah
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 30,
          onPressed: () {
            Navigator.pop(context); // Aksi kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Memposisikan vertikal ke tengah
          crossAxisAlignment: CrossAxisAlignment.center, // Memposisikan horizontal ke tengah
          children: [
            // Tombol "Survey dan Kepuasan"
            ElevatedButton.icon(
              onPressed: _launchSurvey, // Fungsi untuk membuka Google Forms
              icon: Icon(
                Icons.poll, // Ikon berbeda untuk tombol Survey
                color: Colors.white,
              ),
              label: Text(
                'Survey dan Kepuasan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Warna teks putih
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Warna latar belakang biru
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25), // Ukuran padding tombol
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Membuat sudut melengkung
                ),
              ),
            ),
            SizedBox(height: 20), // Jarak antara dua tombol

            // Tombol "Komentar Untuk Kami"
            ElevatedButton.icon(
              onPressed: _launchWhatsApp, // Fungsi untuk membuka WhatsApp
              icon: Icon(
                Icons.comment, // Ikon berbeda untuk tombol Komentar
                color: Colors.white,
              ),
              label: Text(
                'Komentar Untuk Kami',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Warna teks putih
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Warna latar belakang biru
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25), // Ukuran padding tombol
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Membuat sudut melengkung
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
