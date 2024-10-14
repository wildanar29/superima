import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../domain/entities/user.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController medicalNoController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noKKController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
        // Background image
        Image.asset(
        'assets/biruLatar.png', // Background image path
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),

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


          // Other images on top of background
      Positioned(
        top: 130,
        left: -45,
        child: Image.asset(
          'assets/putih.png', // Image for the white background
          width: 500,
          height: 400,
          fit: BoxFit.contain,
        ),
      ),

      Positioned(
        top: 40,
        left: 145,
        child: Image.asset(
          'assets/SignUp.png', // Image for the "Sign In" icon
          width: 130,
          height: 100,
          fit: BoxFit.contain,
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
            top: 40,
            left: 10, // Atur posisi tombol di dekat pojok kiri atas
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 40), // Tanda panah kembali
              onPressed: () {
                Navigator.pop(context); // Kembali ke halaman sebelumnya (LoginPage)
              },
            ),
          ),

          Positioned(
            top: 115, // Mengatur jarak vertikal dari atas
            left: 50, // Mengatur jarak dari kiri
            right: 50, // Mengatur jarak dari kanan
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is SignupFailure) {
                  _showFailureDialog(context, 'Pendaftaran Gagal', 'Silakan coba lagi.');
                } else if (state is SignupSuccess) {
                  _showSuccessDialog(context);
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch, // Membuat semua elemen merentang di seluruh lebar
                    children: [
                        // Medical No TextField
                        TextField(
                          controller: medicalNoController,
                          decoration: InputDecoration(labelText: 'Medical No'),
                        ),
                        SizedBox(height: 10), // Jarak antar TextField

                        // Phone Number TextField
                        TextField(
                          controller: phoneNumberController,
                          decoration: InputDecoration(labelText: 'Phone Number'),
                        ),
                        SizedBox(height: 12),

                        // NIK TextField
                        TextField(
                          controller: nikController,
                          decoration: InputDecoration(labelText: 'NIK'),
                        ),
                        SizedBox(height: 12),

                        // Password TextField
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true, // Menyembunyikan teks saat mengetik password
                        ),
                        SizedBox(height: 12),

                        // Email TextField
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                        ),
                        SizedBox(height: 12),

                        // No.KK TextField
                        TextField(
                          controller: noKKController,
                          decoration: InputDecoration(labelText: 'No.KK'),
                        ),
                        SizedBox(height: 16), // Jarak lebih besar sebelum tombol

                        // Sign Up Button
                        ElevatedButton(
                          onPressed: () {
                            _showConfirmationDialog(context); // Tampilkan popup konfirmasi
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellowAccent, // Warna latar belakang tombol
                            padding: EdgeInsets.symmetric(vertical: 16), // Ukuran tombol
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0), // Sudut melengkung tombol
                              ),
                            ),
                          child: Text(
                            'Daftarkan',
                            style: TextStyle(
                              fontSize: 20, // Ukuran teks tombol
                              fontWeight: FontWeight.bold, // Teks tebal
                              color: Colors.black, // Warna teks pada tombol
                            ),
                          ),
                        ),
                      ],
                    ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan popup konfirmasi
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Data'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah data berikut sudah benar?'),
                SizedBox(height: 10),
                Text('Medical No: ${medicalNoController.text}'),
                Text('Phone Number: ${phoneNumberController.text}'),
                Text('NIK: ${nikController.text}'),
                Text('Email: ${emailController.text}'),
                Text('No.KK: ${noKKController.text}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup popup jika batal
              },
            ),
            TextButton(
              child: Text('Lanjutkan'),
              onPressed: () {
                _proceedSignup(context); // Lanjutkan proses signup jika konfirmasi
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk melanjutkan proses signup setelah konfirmasi
  void _proceedSignup(BuildContext context) {
    final medicalNo = medicalNoController.text;
    final phoneNumber = phoneNumberController.text;
    final nik = nikController.text;
    final password = passwordController.text;
    final email = emailController.text;
    final noKK = noKKController.text;

    final user = User(
      medicalNo: medicalNo,
      phoneNumber: phoneNumber,
      nik: nik,
      password: password,
      email: email,
      noKK: noKK,
    );

    // Memicu event signup setelah konfirmasi
    BlocProvider.of<AuthBloc>(context).add(SignupEvent(user));

    // Tutup dialog konfirmasi
    Navigator.of(context).pop();
  }

  // Fungsi untuk menampilkan popup sukses
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pendaftaran Berhasil'),
          content: Text('Anda telah berhasil mendaftar. Silakan login menggunakan akun Anda.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog popup
                Navigator.pushReplacementNamed(context, '/'); // Pindah ke halaman login
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan popup gagal
  void _showFailureDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Coba Lagi'),
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
