import 'package:flutter/material.dart';
import 'package:mobile_rsi/features/auth/domain/repositories/auth_repository.dart';

class PendaftaranPasienTunaiPage extends StatefulWidget {
  final Map<String, dynamic> patientData;
  final AuthRepository authRepository;

  PendaftaranPasienTunaiPage({
    required this.patientData,
    required this.authRepository,
  });

  @override
  _PendaftaranPasienTunaiPageState createState() => _PendaftaranPasienTunaiPageState();
}

class _PendaftaranPasienTunaiPageState extends State<PendaftaranPasienTunaiPage> {
  String? selectedName; // Variabel untuk menyimpan nama yang dipilih dari dropdown
  String? selectedMedicalNo; // Variabel untuk menyimpan medicalNo terkait

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrasi Poli Klinik'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Keterangan peserta di atas dropdown
            Text(
              'Peserta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            // Menggunakan FutureBuilder untuk mendapatkan No KK dari authRepository
            FutureBuilder<String?>(
              future: widget.authRepository.getNoKKByMedicalNo(widget.patientData['MedicalNo']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator()); // Tampilkan loading selama mengambil data
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Tampilkan error jika terjadi kesalahan
                } else if (snapshot.hasData && snapshot.data != null) {
                  String noKK = snapshot.data!; // Dapatkan No KK dari hasil snapshot

                  // Setelah mendapatkan No KK, gunakan untuk mendapatkan map medicalNo dan nama pasien
                  return FutureBuilder<Map<String, String>?>(
                    future: widget.authRepository.getMedicalNoByNoKK(noKK), // Panggil API untuk mendapatkan map medicalNo dan nama pasien
                    builder: (context, medicalNoSnapshot) {
                      if (medicalNoSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator()); // Tampilkan loading saat mengambil daftar medicalNo
                      } else if (medicalNoSnapshot.hasError) {
                        return Text('Error: ${medicalNoSnapshot.error}'); // Tampilkan error jika terjadi kesalahan
                      } else if (medicalNoSnapshot.hasData && medicalNoSnapshot.data != null) {
                        Map<String, String> medicalNos = medicalNoSnapshot.data!; // Dapatkan map medicalNo dan nama pasien

                        // Tampilkan dropdown berisi nama pasien
                        return DropdownButton<String>(
                          hint: Text("Pilih Nama Pasien"),
                          value: selectedName,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedName = newValue; // Simpan nama yang dipilih
                              selectedMedicalNo = medicalNos.entries
                                  .firstWhere((entry) => entry.value == newValue)
                                  .key; // Simpan medicalNo terkait
                              print('Medical No: $selectedMedicalNo'); // Print medicalNo saat nama dipilih
                            });
                          },
                          items: medicalNos.values.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value), // Tampilkan nama pasien di dropdown
                            );
                          }).toList(),
                        );
                      } else {
                        return Text('Medical No tidak ditemukan'); // Jika tidak ada medicalNo yang ditemukan
                      }
                    },
                  );
                } else {
                  return Text('No.KK tidak ditemukan'); // Jika tidak ada No KK yang ditemukan
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
