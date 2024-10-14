import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import package url_launcher
import '../pages/pasien_mitra_page.dart';
import '../pages/pasien_tunai_page.dart';
import 'package:mobile_rsi/features/auth/domain/repositories/auth_repository.dart';

class PendaftaranPage extends StatelessWidget {
  final Map<String, dynamic> patientData;
  final AuthRepository authRepository;

  PendaftaranPage({required this.patientData, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pendaftaran',
          style: TextStyle(
            fontSize: 28, // Memperbesar ukuran teks
            fontWeight: FontWeight.bold, // Membuat teks tebal
          ),
        ),
        centerTitle: true, // Menengahkan teks di AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios), // Ikon panah kembali
          iconSize: 35, // Sesuaikan ukuran ikon (misalnya, 30)
          onPressed: () {
            Navigator.pop(context); // Aksi kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                // Kirim data pasien ke PendaftaranPasienMitraPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PendaftaranPasienMitraPage(
                            patientData: patientData,
                            authRepository: authRepository),
                  ),
                );
              },
              child: Image.asset(
                'assets/PasienMitra.png',
                // Ganti dengan path gambar untuk tombol Pasien Mitra
                height: 100, // Sesuaikan ukuran gambar
                fit: BoxFit.contain, // Pastikan gambar tidak terpotong
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Kirim data pasien ke PendaftaranPasienTunaiPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PendaftaranPasienTunaiPage(
                            patientData: patientData,
                            authRepository: authRepository),
                  ),
                );
              },
              child: Image.asset(
                'assets/PasienTunai.png',
                // Ganti dengan path gambar untuk tombol Pasien Tunai
                height: 100, // Sesuaikan ukuran gambar
                fit: BoxFit.contain, // Pastikan gambar tidak terpotong
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                const url =
                    'https://play.google.com/store/apps/details?id=app.bpjs.mobile&hl=id';
                Uri uri = Uri.parse(url); // Konversi ke Uri
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication); // Gunakan mode aplikasi eksternal
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Image.asset(
                'assets/PasienBpjs.png',
                // Ganti dengan path gambar untuk tombol Pasien BPJS
                height: 100, // Sesuaikan ukuran gambar
                fit: BoxFit.contain, // Pastikan gambar tidak terpotong
              ),
            ),
          ],
        ),
      ),
    );
  }
}
