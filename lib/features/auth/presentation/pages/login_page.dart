import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';


class LoginPage extends StatelessWidget {
  final TextEditingController nikOrMedicalNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper( // Membungkus LoginPage dengan BackgroundWrapper
      child: Scaffold(
        backgroundColor: Colors.transparent, // Agar background dari Stack tetap terlihat
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              _showFailureDialog(context); // Menampilkan popup jika login gagal
            } else if (state is AuthSuccess) {
              // Ambil medicalNo dari AuthSuccess state
              final medicalNo = state.medicalNo; // Pastikan medicalNo diambil dari AuthSuccess
              Navigator.pushReplacementNamed(context, '/home', arguments: medicalNo);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return Stack(
              children: [
              // Pindahkan posisi form di atas gambar putih.png
              Positioned(
              top: 390, // Sesuaikan posisi vertikal form di atas putih.png
              left: 60, // Sesuaikan posisi horizontal dari kiri
              right: 50, // Sesuaikan posisi horizontal dari kanan
              child: Column(
                children: [
                  TextField(
                    controller: nikOrMedicalNoController,
                    textAlign: TextAlign.center, // Posisikan teks yang diketik di tengah
                    decoration: InputDecoration(
                      hintText: 'No. Rekam Medis atau NIK', // Gunakan hintText untuk teks dalam input
                      hintStyle: TextStyle(
                        color: Colors.black, // Warna teks sesuai gambar
                        fontWeight: FontWeight.bold, // Mengatur teks menjadi tebal
                      ),
                      filled: true,
                      fillColor: Colors.lightBlueAccent, // Warna latar belakang sesuai gambar
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0), // Posisikan teks di tengah secara vertikal
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Membuat sudut melengkung
                        borderSide: BorderSide(color: Colors.transparent), // Tanpa border saat tidak fokus
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Membuat sudut melengkung
                        borderSide: BorderSide(color: Colors.transparent), // Tanpa border saat fokus
                      ),
                    ),
                  ),
                  SizedBox(height: 16), // Jarak antar TextField
                  TextField(
                    controller: passwordController,
                    textAlign: TextAlign.center, // Posisikan teks yang diketik di tengah
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold, // Mengatur teks menjadi tebal
                      ),
                      filled: true,
                      fillColor: Colors.lightBlueAccent, // Warna latar belakang sesuai gambar
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0), // Posisikan teks di tengah secara vertikal
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Membuat sudut melengkung
                        borderSide: BorderSide(color: Colors.transparent), // Tanpa border saat tidak fokus
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Membuat sudut melengkung
                        borderSide: BorderSide(color: Colors.transparent), // Tanpa border saat fokus
                      ),
                    ),
                    obscureText: true, // Untuk menyembunyikan teks saat mengetik password
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final nikOrMedicalNo = nikOrMedicalNoController.text;
                      final password = passwordController.text;
                      BlocProvider.of<AuthBloc>(context).add(LoginEvent(nikOrMedicalNo, password));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan, // Warna latar belakang tombol biru
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Membuat sudut melengkung
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 4), // Ukuran padding untuk membuat tombol lebih lebar dan tinggi
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white, // Warna teks putih
                        fontWeight: FontWeight.bold, // Membuat teks menjadi tebal
                        fontSize: 25, // Ukuran font
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                  child: Text(
                  'Belum Punya Akun? Daftar Disini',
                  style: TextStyle(
                  fontSize: 16, // Menambahkan ukuran font yang lebih besar
                  fontWeight: FontWeight.bold, // (Opsional) Menambahkan ketebalan pada teks
                   color: Colors.green, // (Opsional) Mengubah warna teks sesuai kebutuhan
                            ),
                          ),
                       ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan popup jika login gagal
  void _showFailureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Gagal'),
          content: Text('Periksa kembali NIK, No.RM, dan Password Anda.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog popup
              },
            ),
          ],
        );
      },
    );
  }
}


class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  BackgroundWrapper({required this.child});

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
          top: 300, // Atur posisi gambar kedua
          left: -40,
          child: Image.asset(
            'assets/putih.png', // Pastikan path gambar benar
            width: 500, // Atur lebar gambar kedua
            height: 320, // Atur tinggi gambar kedua
            fit: BoxFit.contain, // Pastikan gambar menyesuaikan ukuran
          ),
        ),

        Positioned(
          top: 285, // Atur posisi gambar kedua
          left: 145,
          child: Image.asset(
            'assets/SignIn.png', // Pastikan path gambar benar
            width: 130, // Atur lebar gambar kedua
            height: 100, // Atur tinggi gambar kedua
            fit: BoxFit.contain, // Pastikan gambar menyesuaikan ukuran
          ),
        ),

        // Konten di atas gambar
        child,
      ],
    );
  }
}