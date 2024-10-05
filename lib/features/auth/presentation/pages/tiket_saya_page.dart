import 'package:flutter/material.dart';
import '../../domain/repositories/auth_repository.dart';
import 'bukti_booking_page.dart';
import 'bukti_bayar_page.dart';
import 'bukti_daftar_page.dart';
import '../bloc/get_appointment_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_appointment_usecase.dart';
class TiketSayaPage extends StatelessWidget {
  final Map<String, dynamic> patientData; // Tambahkan parameter untuk menerima data patientData
  final AuthRepository authRepository; // Tambahkan parameter untuk menerima authRepository
  final GetAppointmentsUseCase getAppointmentsUseCase; // Tambahkan parameter untuk menerima GetAppointmentsUseCase
  // Konstruktor untuk menerima data
  TiketSayaPage({required this.patientData, required this.authRepository, required this.getAppointmentsUseCase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tiket Saya'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Halaman Tiket Saya untuk ${patientData['FirstName']} ${patientData['LastName']}', // Menampilkan data pasien
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 30),

            // Tombol Bukti Booking
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => GetAppointmentsBloc(getAppointmentsUseCase), // Inisialisasi Bloc dengan use case
                      child: BuktiBookingPage(
                        patientData: patientData, // Kirim data patient
                        authRepository: authRepository, // Kirim AuthRepository yang sesuai
                      ),
                    ),
                  ),
                );
              },
              child: Text('Bukti Booking'),
            ),
            SizedBox(height: 20),

            // Tombol Bukti Bayar
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuktiBayarPage(), // Halaman Bukti Bayar, sesuaikan jika perlu
                  ),
                );
              },
              child: Text('Bukti Bayar'),
            ),
            SizedBox(height: 20),

            // Tombol Bukti Daftar
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuktiDaftarPage(patientData: patientData), // Halaman Bukti Daftar, sesuaikan jika perlu
                  ),
                );
              },
              child: Text('Bukti Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}
