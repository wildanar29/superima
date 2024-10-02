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
      appBar: AppBar(title: Text('Sign Up')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignupFailure) {
            _showFailureDialog(context, 'Pendaftaran Gagal', 'Silakan coba lagi.'); // Menampilkan popup jika signup gagal
          } else if (state is SignupSuccess) {
            _showSuccessDialog(context); // Menampilkan popup setelah signup berhasil
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: medicalNoController,
                  decoration: InputDecoration(labelText: 'Medical No'),
                ),
                TextField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                ),
                TextField(
                  controller: nikController,
                  decoration: InputDecoration(labelText: 'NIK'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: noKKController,
                  decoration: InputDecoration(labelText: 'No.KK'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _showConfirmationDialog(context); // Tampilkan popup konfirmasi
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
          );
        },
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
