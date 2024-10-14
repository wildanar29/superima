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
        centerTitle: true, // Untuk menengahkan teks di AppBar
        title: Text(
          'Tiket Saya',
          style: TextStyle(
            fontSize: 24, // Ukuran teks lebih besar
            fontWeight: FontWeight.bold, // Membuat teks tebal
          ),
        ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios), // Menambahkan ikon panah kembali
        iconSize: 35, // Memperbesar ukuran ikon
        onPressed: () {
          Navigator.pop(context); // Aksi kembali ke halaman sebelumnya
           },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Memposisikan di tengah
          crossAxisAlignment: CrossAxisAlignment.stretch, // Membuat tombol selebar layar
          children: [
            Text(
              'Tiket Saya untuk ${patientData['FirstName']} ${patientData['LastName']}', // Menampilkan data pasien
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold, // Membuat teks lebih tebal
                color: Colors.black, // Warna teks menjadi hitam (judul di atas tombol)
              ),
              textAlign: TextAlign.center, // Menengahkan teks
            ),
            SizedBox(height: 30),

            // Tombol Bukti Booking
            ElevatedButton.icon(
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
              icon: Icon(Icons.book_online, color: Colors.white), // Ikon putih
              label: Text(
                'Bukti Booking',
                style: TextStyle(
                  fontSize: 22, // Ukuran teks diperbesar
                  fontWeight: FontWeight.bold, // Teks tebal
                  color: Colors.white, // Warna teks putih
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Latar belakang biru
                padding: EdgeInsets.symmetric(vertical: 16), // Padding di dalam tombol
              ),
            ),
            SizedBox(height: 20),

            // Tombol Bukti Bayar
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuktiBayarPage(), // Halaman Bukti Bayar, sesuaikan jika perlu
                  ),
                );
              },
              icon: Icon(Icons.receipt, color: Colors.white), // Ikon putih
              label: Text(
                'Bukti Bayar',
                style: TextStyle(
                  fontSize: 22, // Ukuran teks diperbesar
                  fontWeight: FontWeight.bold, // Teks tebal
                  color: Colors.white, // Warna teks putih
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Latar belakang biru
                padding: EdgeInsets.symmetric(vertical: 16), // Padding di dalam tombol
              ),
            ),
            SizedBox(height: 20),

            // Tombol Bukti Daftar
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuktiDaftarPage(patientData: patientData), // Halaman Bukti Daftar, sesuaikan jika perlu
                  ),
                );
              },
              icon: Icon(Icons.assignment, color: Colors.white), // Ikon putih
              label: Text(
                'Bukti Daftar',
                style: TextStyle(
                  fontSize: 22, // Ukuran teks diperbesar
                  fontWeight: FontWeight.bold, // Teks tebal
                  color: Colors.white, // Warna teks putih
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Latar belakang biru
                padding: EdgeInsets.symmetric(vertical: 16), // Padding di dalam tombol
              ),
            ),
          ],
        ),
      ),
    );
  }
}
