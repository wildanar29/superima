import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import package url_launcher
import '../pages/pasien_mitra_page.dart';
import '../pages/pasien_tunai_page.dart';
import 'package:mobile_rsi/features/auth/domain/repositories/auth_repository.dart';

class PendaftaranPage extends StatelessWidget {
  final Map<String, dynamic> patientData;
  final AuthRepository authRepository;

  PendaftaranPage({required this.patientData,required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Pendaftaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Kirim data pasien ke PendaftaranPasienMitraPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PendaftaranPasienMitraPage(patientData: patientData, authRepository: authRepository),
                  ),
                );
              },
              child: Text('Pasien Mitra'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Kirim data pasien ke PendaftaranPasienMitraPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PendaftaranPasienTunaiPage(patientData: patientData, authRepository: authRepository),
                  ),
                );
              },
              child: Text('Pasien Tunai'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                const url = 'https://play.google.com/store/apps/details?id=app.bpjs.mobile&hl=id';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Text('Pasien BPJS'),
            ),
          ],
        ),
      ),
    );
  }
}
