import 'package:flutter/material.dart';
import 'package:mobile_rsi/features/auth/presentation/pages/login_page.dart';


// Halaman pembuka (FirstPage)
class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    super.initState();
    // Delay selama 3 detik sebelum dialihkan ke halaman login
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LoginPage(), // Menggunakan LoginPage() secara langsung
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gambar background pertama
        Image.asset(
          'assets/biruLatar.png', // Pastikan path gambar benar
          fit: BoxFit.cover, // Menutupi seluruh background
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.topCenter,
        ),

        // Gambar kedua di atas background
        Positioned(
          top: 300, // Atur posisi gambar kedua
          left: 1,
          child: Opacity(
            opacity: 0.5, // Mengatur opacity untuk memberikan efek kontras rendah
            child: Image.asset(
              'assets/gedung.png', // Pastikan path gambar benar
              width: 420, // Atur lebar gambar kedua
              height: 545, // Atur tinggi gambar kedua
              fit: BoxFit.cover, // Pastikan gambar menyesuaikan ukuran
            ),
          ),
        ),

        Positioned(
          top: 780, // Atur posisi gambar kedua
          left: 133,
          child: Image.asset(
            'assets/2024.png', // Pastikan path gambar benar
            width: 150, // Atur lebar gambar kedua
            height: 20, // Atur tinggi gambar kedua
            fit: BoxFit.contain, // Pastikan gambar menyesuaikan ukuran
          ),
        ),

        Positioned(
          top: 90, // Atur posisi gambar kedua
          left: -40,
          child: Image.asset(
            'assets/Logo_Rsi.png', // Pastikan path gambar benar
            width: 500, // Atur lebar gambar kedua
            height: 150, // Atur tinggi gambar kedua
            fit: BoxFit.contain, // Pastikan gambar menyesuaikan ukuran
          ),
        ),
        Positioned(
          top: 350, // Atur posisi gambar kedua
          left: 110,
          child: Image.asset(
            'assets/mobile.png', // Pastikan path gambar benar
            width: 200, // Atur lebar gambar kedua
            height: 150, // Atur tinggi gambar kedua
            fit: BoxFit.contain, // Pastikan gambar menyesuaikan ukuran
          ),
        ),
        Positioned(
          top: 300, // Atur posisi gambar kedua
          left: 150,
          child: Image.asset(
            'assets/immaText.png', // Pastikan path gambar benar
            width: 120, // Atur lebar gambar kedua
            height: 150, // Atur tinggi gambar kedua
            fit: BoxFit.contain, // Pastikan gambar menyesuaikan ukuran
          ),
        ),
        Positioned(
          top: 500, // Mengatur posisi indikator loading di bawah gambar
          left: 0,
          right: 0,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20), // Jarak antara gambar dan loading indicator
                CircularProgressIndicator(
                  color: Colors.white, // Warna indikator loading
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
