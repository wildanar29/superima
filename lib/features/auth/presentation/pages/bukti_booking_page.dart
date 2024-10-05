import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Tambahkan Bloc
import '../../domain/repositories/auth_repository.dart';
import '../bloc/get_appointment_bloc.dart';
import '../bloc/appointment_event.dart';
import '../bloc/appointment_state.dart';

class BuktiBookingPage extends StatefulWidget {
  final Map<String, dynamic> patientData; // Tambahkan parameter untuk menerima data patientData
  final AuthRepository authRepository; // Tambahkan parameter untuk menerima authRepository

  // Konstruktor untuk menerima data
  BuktiBookingPage({required this.patientData, required this.authRepository});

  @override
  _BuktiBookingPageState createState() => _BuktiBookingPageState();
}

class _BuktiBookingPageState extends State<BuktiBookingPage> {
  String? selectedStatus; // Variabel untuk menyimpan status yang dipilih

  // Daftar opsi status
  final List<String> statusOptions = [
    'open',
    'confirm',
    'cancel',
    'closed',
    'no response',
    'queue booking'
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Panggil event untuk mengambil daftar janji temu berdasarkan MedicalNo dari patientData
    BlocProvider.of<GetAppointmentsBloc>(context).add(GetAppointmentsEvent(widget.patientData['MedicalNo']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bukti Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Menyusun elemen di sebelah kiri
          children: [
            // Keterangan di atas dropdown
            Text(
              'Pilih Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Dropdown untuk memilih status booking
            DropdownButton<String>(
              hint: Text("Pilih Status Booking"), // Teks saat belum ada pilihan
              value: selectedStatus, // Nilai saat ini
              onChanged: (String? newValue) {
                setState(() {
                  selectedStatus = newValue; // Update nilai yang dipilih
                });
              },
              items: statusOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value), // Teks yang ditampilkan pada setiap opsi
                );
              }).toList(),
              isExpanded: true, // Agar dropdown menyesuaikan lebar layar
            ),
            SizedBox(height: 20),

            // Menampilkan status yang dipilih
            Text(
              selectedStatus != null ? "Status Terpilih: $selectedStatus" : "Belum ada status yang dipilih",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),

            // Menggunakan BlocBuilder untuk menampilkan daftar janji temu
            Expanded(
              child: BlocBuilder<GetAppointmentsBloc, AppointmentState>(
                builder: (context, state) {
                  if (state is AppointmentLoading) {
                    return Center(child: CircularProgressIndicator()); // Loading state
                  } else if (state is AppointmentLoaded) {
                    // Menampilkan daftar janji temu
                    final appointments = state.appointments;

                    // Filter janji temu berdasarkan status yang dipilih di dropdown
                    final filteredAppointments = selectedStatus != null
                        ? appointments.where((appointment) => appointment.status.toLowerCase() == selectedStatus?.toLowerCase()).toList()
                        : appointments; // Tampilkan semua jika belum ada status yang dipilih

                    return ListView.builder(
                      itemCount: filteredAppointments.length,
                      itemBuilder: (context, index) {
                        final appointment = filteredAppointments[index];
                        return ListTile(
                          title: Text('Appointment ID: ${appointment.appointmentNo}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('No.Antrian: ${appointment.appointmentQue}'),
                              Text('Tanggal: ${appointment.appointmentDate}'),
                              Text('Waktu: ${appointment.appointmentTime}'),
                              Text('Poli: ${appointment.serviceUnitName}'),
                              Text('Dokter: ${appointment.paramedicName}'),
                              Text('Status: ${appointment.status}'),


                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is AppointmentError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return Center(child: Text('Tidak ada janji temu yang tersedia'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
