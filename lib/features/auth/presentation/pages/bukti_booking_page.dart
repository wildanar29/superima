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
    'Open',
    'Confirm',
    'Cancel',
    'Closed',
    'No Response',
    'Queue Booking'
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
        centerTitle: true,
        title: Text(
          'Bukti Booking',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 35,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                border: Border.all(
                  color: Colors.blue,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                hint: Text("Pilih Status Booking"),
                value: selectedStatus,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStatus = newValue;
                  });
                },
                items: statusOptions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                isExpanded: true,
                underline: SizedBox(),
                icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
              ),
            ),
            SizedBox(height: 20),

            Text(
              selectedStatus != null
                  ? "Status Terpilih: $selectedStatus"
                  : "Belum ada status yang dipilih",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),

            Expanded(
              child: BlocBuilder<GetAppointmentsBloc, AppointmentState>(
                builder: (context, state) {
                  if (state is AppointmentLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is AppointmentLoaded) {
                    final appointments = state.appointments;

                    final filteredAppointments = selectedStatus != null
                        ? appointments
                        .where((appointment) =>
                    appointment.status.toLowerCase() ==
                        selectedStatus?.toLowerCase())
                        .toList()
                        : appointments;

                    return ListView.builder(
                      itemCount: filteredAppointments.length,
                      itemBuilder: (context, index) {
                        final appointment = filteredAppointments[index];

                        Color statusColor;
                        switch (appointment.status.toLowerCase()) {
                          case 'open':
                            statusColor = Colors.green;
                            break;
                          case 'queue booking':
                            statusColor = Colors.orange;
                            break;
                          case 'cancel':
                            statusColor = Colors.yellowAccent;
                            break;
                          case 'closed':
                            statusColor = Colors.red;
                            break;
                          default:
                            statusColor = Colors.blue;
                        }

                        return Container(
                          margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              'Appointment ID: ${appointment.appointmentNo}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('No.Antrian: ${appointment.appointmentQue}'),
                                Text('Tanggal: ${appointment.appointmentDate}'),
                                Text('Waktu: ${appointment.appointmentTime}'),
                                Text('Poli: ${appointment.serviceUnitName}'),
                                Text('Dokter: ${appointment.paramedicName}'),
                                Row(
                                  children: [
                                    Text('Status: ${appointment.status}'),
                                    SizedBox(width: 10),
                                    if (appointment.status.toLowerCase() ==
                                        'confirm')
                                      Icon(Icons.check_circle,
                                          color: Colors.green, size: 18)
                                    else
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: statusColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is AppointmentError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return Center(
                      child: Text('Tidak ada janji temu yang tersedia'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}