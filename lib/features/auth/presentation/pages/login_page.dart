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
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
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
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: nikOrMedicalNoController,
                  decoration: InputDecoration(labelText: 'NIK or Medical No'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final nikOrMedicalNo = nikOrMedicalNoController.text;
                    final password = passwordController.text;
                    BlocProvider.of<AuthBloc>(context).add(LoginEvent(nikOrMedicalNo, password));
                  },
                  child: Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text('Don\'t have an account? Sign up here!'),
                )
              ],
            ),
          );
        },
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
