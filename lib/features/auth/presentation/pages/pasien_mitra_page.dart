import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile_rsi/features/auth/domain/repositories/auth_repository.dart';
import '../../data/repositories/paramedic_repository_impl.dart';
import '../../domain/entities/paramedic.dart';
import '../../data/repositories/poliklinik_repository_impl.dart';
import '../../domain/entities/poliklinik.dart';
import '../../data/repositories/shedule_repository_impl.dart'; // Import repository jadwal
import '../../domain/entities/appointment_create.dart';
import '../../domain/usecases/create_appointment_usecase.dart';
import '../../data/repositories/appointment_repository_impl.dart';
import '../../../../core/network/api_service.dart';

class PendaftaranPasienMitraPage extends StatefulWidget {
  final Map<String, dynamic> patientData;
  final AuthRepository authRepository;

  PendaftaranPasienMitraPage({
    required this.patientData,
    required this.authRepository,
  });

  @override
  _PendaftaranPasienMitraPageState createState() =>
      _PendaftaranPasienMitraPageState();
}

class _PendaftaranPasienMitraPageState
    extends State<PendaftaranPasienMitraPage> {
  String? selectedName;
  String? selectedMedicalNo;
  String? selectedDoctorName;
  String? selectedDoctorId;
  String? selectedPoliName; // Untuk menyimpan nama poli klinik yang dipilih
  String? selectedPoliId; // Untuk menyimpan ID poli klinik terkait
  DateTime? selectedDate;
  Future<List<Paramedic>>? _paramedicsFuture;
  Future<List<PoliKlinik>>? _poliKlinikFuture; // Future untuk menyimpan data poli klinik
  Future<List<PoliKlinik>>? _allPoliKlinikFuture; // Future untuk semua poli
  Future<List<Paramedic>>? _doctorsByPoliFuture; // Future untuk menyimpan data dokter berdasarkan poli

  // Tambahkan variabel untuk menyimpan status ketersediaan jadwal
  bool? scheduleAvailable; // Status apakah jadwal tersedia
  String? startTime;
  String? endTime;
  final ParamedicScheduleRepositoryImpl scheduleRepository =
  ParamedicScheduleRepositoryImpl(); // Repository jadwal

  // Tambahkan variabel untuk menyimpan pilihan radio
  String? selectedOption = 'dokter'; // Default: dokter

  @override
  void initState() {
    super.initState();
    _paramedicsFuture = _getAllParamedics();
    _allPoliKlinikFuture = _getAllPoliKlinik(); // Ambil semua poli klinik
  }

  Future<List<Paramedic>> _getAllParamedics() async {
    ParamedicRepositoryImpl paramedicRepository = ParamedicRepositoryImpl();
    return await paramedicRepository.getAllParamedics();
  }

  Future<List<PoliKlinik>> _getPoliKlinikByParamedicId(String paramedicId) async {
    PoliKlinikRepositoryImpl poliKlinikRepository = PoliKlinikRepositoryImpl();
    return await poliKlinikRepository.getPoliKlinikByParamedicId(paramedicId);
  }

  Future<List<PoliKlinik>> _getAllPoliKlinik() async {
    PoliKlinikRepositoryImpl poliKlinikRepository = PoliKlinikRepositoryImpl();
    return await poliKlinikRepository.getAllPoliKlinik();
  }

  Future<List<Paramedic>> _getDoctorsByPoli(String poliId) async {
    ParamedicRepositoryImpl paramedicRepository = ParamedicRepositoryImpl();
    return await paramedicRepository.getDoctorsByPoli(poliId); // Panggil API untuk mengambil dokter berdasarkan poli
  }

  // Fungsi untuk memeriksa apakah ada jadwal dokter untuk kombinasi yang dipilih
  Future<void> _checkSchedule() async {
    if (selectedDoctorId != null && selectedPoliId != null && selectedDate != null) {
      try {
        // Panggil fungsi untuk mendapatkan jadwal
        Map<String, String?> schedule = await scheduleRepository.getParamedicSchedule(
          DateFormat('yyyy-MM-dd').format(selectedDate!), // Tanggal yang dipilih
          DateFormat('yyyy-MM-dd').format(selectedDate!), // Gunakan tanggal yang sama untuk start dan end
          selectedDoctorId!, // ID Dokter yang dipilih
          selectedPoliId!, // ID Poli yang dipilih
        );

        setState(() {
          // Cek apakah StartTime1 dan EndTime1 ada dalam response
          if (schedule['StartTime1'] != null && schedule['EndTime1'] != null) {
            scheduleAvailable = true; // Ada jadwal
            startTime = schedule['StartTime1'];
            endTime = schedule['EndTime1'];

            // Tampilkan popup dengan jadwal yang tersedia dan nama dokter serta poli
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Jadwal Tersedia'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Jadwal tersedia untuk:'),
                      SizedBox(height: 10),
                      Text('Dokter: $selectedDoctorName'),
                      Text('Poli: $selectedPoliName'),
                      SizedBox(height: 10),
                      Text('Waktu Mulai: $startTime'),
                      Text('Waktu Selesai: $endTime'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else {
            scheduleAvailable = false; // Tidak ada jadwal
            // Tampilkan popup jika tidak ada jadwal yang tersedia
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Jadwal Tidak Tersedia'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Tidak ada jadwal untuk:'),
                      SizedBox(height: 10),
                      Text('Dokter: $selectedDoctorName'),
                      Text('Poli: $selectedPoliName'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        });
      } catch (e) {
        print('Error checking schedule: $e');
        setState(() {
          scheduleAvailable = false; // Tidak ada jadwal
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Terjadi kesalahan saat memeriksa jadwal.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        });
      }
    }
  }



  // Fungsi yang dipanggil ketika poli dipilih
  Future<void> _onPoliSelected(String? newValue, List<PoliKlinik> polikliniks) async {
    setState(() {
      selectedPoliName = newValue;
      selectedPoliId = polikliniks
          .firstWhere((poli) => poli.serviceUnitName == newValue)
          .serviceUnitID;

      // Reset dokter yang dipilih
      // selectedDoctorName = null;

      // Muat data dokter berdasarkan poli yang dipilih
      _doctorsByPoliFuture = _getDoctorsByPoli(selectedPoliId!);
    });
  }

  // Fungsi yang dipanggil ketika dokter dipilih
  Future<void> _onDoctorSelected(String? newValue, List<Paramedic> paramedics) async {
    setState(() {
      selectedDoctorName = newValue;
      selectedDoctorId = paramedics
          .firstWhere((doctor) => doctor.paramedicName == newValue)
          .paramedicID;
      _checkSchedule();
    });
    // Setelah dokter dipilih, panggil API untuk mendapatkan Poli Klinik berdasarkan dokter
    _poliKlinikFuture = _getPoliKlinikByParamedicId(selectedDoctorId!);
    setState(() {}); // Refresh UI setelah Future berubah
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('id', 'ID'),
        const Locale('en', 'US'),
      ],
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Pasien Mitra',
            style: TextStyle(
              fontSize: 24, // Ukuran teks lebih besar
              fontWeight: FontWeight.bold, // Membuat teks tebal
            ),
          ),
          centerTitle: true, // Menengahkan teks di AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios), // Tambahkan ikon panah kembali
          iconSize: 34, // Perbesar ukuran ikon
          onPressed: () {
            Navigator.pop(context); // Aksi kembali ke halaman sebelumnya
          },
        ),
      ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Peserta :',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              // FutureBuilder untuk mendapatkan NoKK dan MedicalNo pasien
              FutureBuilder<String?>(
                future: widget.authRepository.getNoKKByMedicalNo(widget.patientData['MedicalNo']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data != null) {
                    String noKK = snapshot.data!;
                    return FutureBuilder<Map<String, String>?>(
                      future: widget.authRepository.getMedicalNoByNoKK(noKK),
                      builder: (context, medicalNoSnapshot) {
                        if (medicalNoSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (medicalNoSnapshot.hasError) {
                          return Text('Error: ${medicalNoSnapshot.error}');
                        } else if (medicalNoSnapshot.hasData && medicalNoSnapshot.data != null) {
                          Map<String, String> medicalNos = medicalNoSnapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Padding dalam container
                                decoration: BoxDecoration(
                                  color: Colors.blue[50], // Latar belakang biru muda
                                  border: Border.all(
                                    color: Colors.blue, // Warna border biru
                                    width: 2.0, // Ketebalan border
                                  ),
                                  borderRadius: BorderRadius.circular(10), // Membuat sudut border melengkung
                                ),
                                child: DropdownButton<String>(
                                  hint: Text("Pilih Nama Pasien"),
                                  value: selectedName,
                                  isExpanded: true, // Agar dropdown menyesuaikan lebar container
                                  underline: SizedBox(), // Menghilangkan garis bawah default pada dropdown
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedName = newValue;
                                      selectedMedicalNo = medicalNos.entries
                                          .firstWhere((entry) => entry.value == newValue)
                                          .key;
                                    });
                                  },
                                  items: medicalNos.values.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(height: 20),

                              Text(
                                'Pilih Tanggal Appointment :',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),

                              ElevatedButton(
                                onPressed: () => _selectDate(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlueAccent, // Warna background biru
                                  padding: EdgeInsets.symmetric(horizontal: 142, vertical: 4), // Padding tombol
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), // Membuat sudut tombol melengkung
                                  ),
                                ),
                                child: Text(
                                  selectedDate != null
                                      ? '${DateFormat('yyyy-MM-dd').format(selectedDate!)}'
                                      : 'Pilih Tanggal',
                                 style: TextStyle(
                                 color: Colors.black, // Warna teks menjadi putih
                                   fontSize: 16, // Ukuran teks lebih besar
                                 ),
                                ),
                              ),

                              SizedBox(height: 20),

                              // Radio Button untuk pilihan
                              Text(
                                'Pilih Berdasarkan:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Mengatur jarak merata antara elemen
                                children: [
                                  Column(
                                    children: [
                                      Radio<String>(
                                        value: 'dokter',
                                        groupValue: selectedOption,
                                        onChanged: (String? value) {
                                          setState(() {
                                            selectedOption = value;
                                            selectedPoliName = null;
                                          });
                                        },
                                      ),
                                      SizedBox(height: 2), // Jarak antara radio button dan teks
                                      Text(
                                        'Dokter',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Radio<String>(
                                        value: 'poli',
                                        groupValue: selectedOption,
                                        onChanged: (String? value) {
                                          setState(() {
                                            selectedOption = value;
                                            selectedPoliName = null;
                                          });
                                        },
                                      ),
                                      SizedBox(height: 2), // Jarak antara radio button dan teks
                                      Text(
                                        'Poli',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20), // Jarak antara radio button dan teks

                              // Tampilkan dropdown berdasarkan pilihan radio button
                              if (selectedOption == 'dokter') ...[
                                _buildDokterDropdown(),
                                SizedBox(height: 20),
                                if (selectedDoctorId != null) _buildPoliDropdownBasedOnDoctor()
                              ] else ...[
                                _buildAllPoliDropdown(),
                                SizedBox(height: 20),
                                if (selectedPoliId != null) _buildDoctorDropdownBasedOnPoli(),
                              ],

                              // Tampilkan status jadwal setelah poli dipilih
                              if (scheduleAvailable != null) ...[
                                SizedBox(height: 20),
                                Text(scheduleAvailable!
                                    ? 'Jadwal tersedia untuk dokter dan poli yang dipilih.'
                                    : 'Tidak ada jadwal untuk dokter dan poli yang dipilih.'),
                                if (scheduleAvailable!) ...[
                                  SizedBox(height: 10),
                                  Text('Waktu Mulai: $startTime'),
                                  Text('Waktu Selesai: $endTime'),
                                ],
                              ],

                              SizedBox(height: 20),

                              // Tombol untuk submit appointment
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center, // Mengatur konten berada di tengah secara horizontal
                                children: [
                                  SizedBox(height: 30), // Jarak antara konten sebelumnya dan tombol gambar

                                  Center( // Membuat gambar berada di tengah
                                    child: GestureDetector(
                                      onTap: (scheduleAvailable != null && scheduleAvailable == true) ? () {
                                        if (selectedMedicalNo != null && selectedPoliId != null && selectedDoctorId != null && selectedDate != null && selectedName != null) {
                                          // Tambahkan logika untuk mengirim data appointment
                                          _submitAppointment();
                                        } else {
                                          // Tampilkan pesan jika ada data yang belum dipilih
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Pastikan semua data sudah dipilih')),
                                          );
                                        }
                                      } : null, // Tombol dinonaktifkan jika jadwal tidak tersedia atau belum dicek
                                      child: Opacity(
                                        opacity: (scheduleAvailable != null && scheduleAvailable == true) ? 1.0 : 0.5, // Ubah opacity jika tombol dinonaktifkan
                                        child: Image.asset(
                                          'assets/TombolDaftar.png', // Ganti dengan path gambar tombol
                                          width: 200, // Sesuaikan ukuran gambar
                                          height: 100, // Sesuaikan tinggi gambar
                                          fit: BoxFit.contain, // Pastikan gambar tidak terpotong
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 20), // Jarak setelah tombol gambar
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Text('Medical No tidak ditemukan');
                        }
                      },
                    );
                  } else {
                    return Text('No.KK tidak ditemukan');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dropdown untuk memilih dokter
  Widget _buildDokterDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Dokter :',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        FutureBuilder<List<Paramedic>>(
          future: _paramedicsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data != null) {
              List<Paramedic> paramedics = snapshot.data!;

              // Filter duplicates based on paramedicName
              List<Paramedic> uniqueParamedics = paramedics.toSet().toList();

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Padding dalam container
                decoration: BoxDecoration(
                  color: Colors.blue[50], // Latar belakang biru muda
                  border: Border.all(
                    color: Colors.blue, // Warna border biru
                    width: 2.0, // Ketebalan border
                  ),
                  borderRadius: BorderRadius.circular(10), // Membuat sudut border melengkung
                ),
                child: DropdownButton<String>(
                  hint: Text("Pilih Dokter"),
                  value: paramedics.any((doctor) => doctor.paramedicName == selectedDoctorName)
                      ? selectedDoctorName
                      : null,  // Set ke null jika selectedDoctorName tidak valid
                  onChanged: (String? newValue) async {
                    await _onDoctorSelected(newValue, paramedics);
                  },
                  items: paramedics.map<DropdownMenuItem<String>>((Paramedic doctor) {
                    return DropdownMenuItem<String>(
                      value: doctor.paramedicName,
                      child: Text(doctor.paramedicName),
                    );
                  }).toList(),
                ),
              );
            } else {
              return Text('Tidak ada dokter yang tersedia');
            }
          },
        ),

      ],
    );
  }

  // Widget untuk menampilkan dropdown poli berdasarkan dokter yang dipilih
  Widget _buildPoliDropdownBasedOnDoctor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Poli Klinik Berdasarkan Dokter:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        FutureBuilder<List<PoliKlinik>>(
          future: _poliKlinikFuture, // Panggil Future untuk mendapatkan data poli klinik berdasarkan dokter
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
              List<PoliKlinik> polikliniks = snapshot.data!;

              // Periksa apakah selectedPoliName ada dalam list, jika tidak, set ke null
              if (selectedPoliName != null && !polikliniks.any((poli) => poli.serviceUnitName == selectedPoliName)) {
                // selectedPoliName = null; // Reset jika nilai tidak valid
              }

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Padding dalam container
                decoration: BoxDecoration(
                  color: Colors.blue[50], // Latar belakang biru muda
                  border: Border.all(
                    color: Colors.blue, // Warna border biru
                    width: 2.0, // Ketebalan border
                  ),
                  borderRadius: BorderRadius.circular(10), // Membuat sudut border melengkung
                ),
                child: DropdownButton<String>(
                  hint: Text("Pilih Poli Klinik"),
                  value: polikliniks.any((poli) => poli.serviceUnitName == selectedPoliName)
                      ? selectedPoliName
                      : null,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPoliName = newValue;
                      selectedPoliId = polikliniks
                          .firstWhere((poli) => poli.serviceUnitName == newValue)
                          .serviceUnitID;
                      _checkSchedule();
                    });
                  },
                  items: polikliniks.map<DropdownMenuItem<String>>((PoliKlinik poli) {
                    return DropdownMenuItem<String>(
                      value: poli.serviceUnitName,
                      child: Text(poli.serviceUnitName), // Tampilkan nama poli
                    );
                  }).toList(),
                ),
              );
            } else {
              return Text('Tidak ada poli klinik yang tersedia');
            }
          },
        ),
      ],
    );
  }


  // Dropdown untuk menampilkan semua poli
  Widget _buildAllPoliDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Poli Klinik :',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        FutureBuilder<List<PoliKlinik>>(
          future: _allPoliKlinikFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data != null) {
              List<PoliKlinik> polikliniks = snapshot.data!;
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Padding dalam container
                decoration: BoxDecoration(
                  color: Colors.blue[50], // Latar belakang biru muda
                  border: Border.all(
                    color: Colors.blue, // Warna border biru
                    width: 2.0, // Ketebalan border
                  ),
                  borderRadius: BorderRadius.circular(10), // Membuat sudut border melengkung
                ),
                child: DropdownButton<String>(
                  hint: Text("Pilih Poli Klinik"),
                  value: (polikliniks.isNotEmpty && selectedPoliName != null && polikliniks.any((poli) => poli.serviceUnitName == selectedPoliName))
                      ? selectedPoliName
                      : null, // Jika tidak ada data, maka value menjadi null
                  onChanged: (String? newValue) async {
                    await _onPoliSelected(newValue, polikliniks);
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: '', // Opsi kosong
                      child: Text('Tidak Ada Poli Terpilih'), // Teks untuk opsi kosong
                    ),
                    ...polikliniks.map<DropdownMenuItem<String>>((PoliKlinik poli) {
                      return DropdownMenuItem<String>(
                        value: poli.serviceUnitName,
                        child: Text(poli.serviceUnitName), // Menampilkan serviceUnitName
                      );
                    }).toList(),
                  ],
                ),
              );
            } else {
              return Text('Tidak ada poli klinik yang tersedia');
            }
          },
        ),
      ],
    );
  }

  // Dropdown untuk memilih dokter berdasarkan poli yang dipilih
  Widget _buildDoctorDropdownBasedOnPoli() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Dokter Berdasarkan Poli:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        FutureBuilder<List<Paramedic>>(
          future: _doctorsByPoliFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data != null) {
              List<Paramedic> paramedics = snapshot.data!;

              // Filter duplicate values based on paramedicID
              List<Paramedic> uniqueParamedics = paramedics.toSet().toList();

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Padding dalam container
                decoration: BoxDecoration(
                  color: Colors.blue[50], // Latar belakang biru muda
                  border: Border.all(
                    color: Colors.blue, // Warna border biru
                    width: 2.0, // Ketebalan border
                  ),
                  borderRadius: BorderRadius.circular(10), // Membuat sudut border melengkung
                ),
                child: DropdownButton<String>(
                  hint: Text("Pilih Dokter"),
                  value: paramedics.any((doctor) => doctor.paramedicName == selectedDoctorName)
                      ? selectedDoctorName
                      : null,  // Set ke null jika selectedDoctorName tidak valid
                  onChanged: (String? newValue) async {
                    await _onDoctorSelected(newValue, paramedics);
                  },
                  items: paramedics.map<DropdownMenuItem<String>>((Paramedic doctor) {
                    return DropdownMenuItem<String>(
                      value: doctor.paramedicName,
                      child: Text(doctor.paramedicName),
                    );
                  }).toList(),
                ),
              );
            } else {
              return Text('Tidak ada dokter yang tersedia');
            }
          },
        ),
      ],
    );
  }



  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    DateTime today = DateTime.now();
    DateTime initialDate = today.add(Duration(days: 1));
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime(2101),
      locale: const Locale('id', 'ID'),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Fungsi untuk mengirim data pendaftaran appointment
  // Fungsi untuk mengirim data pendaftaran appointment
  void _submitAppointment() async {
    String dateTimeString = widget.patientData['DateOfBirth_yMdHms'];

    // Jika tipe data sudah dalam String
    DateTime parsedDate = DateTime.parse(dateTimeString);

    // Mengubahnya menjadi format hanya tanggal (tanpa waktu)
    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    print(widget.patientData);
    try {
      AppointmentRequest appointmentRequest = AppointmentRequest(
        serviceUnitID: selectedPoliId!,
        paramedicID: selectedDoctorId!,
        appointmentDate: DateFormat('yyyy-MM-dd').format(selectedDate!),
        appointmentTime: 'AUTO', // Atur waktu appointment
        patientID: widget.patientData['PatientID'] ?? '', // Default ke string kosong jika null
        firstName: widget.patientData['FirstName'] ?? '', // Default ke string kosong jika null
        middleName: widget.patientData['MiddleName'] ?? '', // Default ke string kosong jika null
        lastName: widget.patientData['LastName'] ?? '', // Default ke string kosong jika null
        dateOfBirth: formattedDate ?? '', // Default ke string kosong jika null
        streetName: widget.patientData['StreetName'] ?? '', // Default ke string kosong jika null
        district: widget.patientData['District'] ?? '', // Default ke string kosong jika null
        county: widget.patientData['County'] ?? '', // Default ke string kosong jika null
        city: widget.patientData['City'] ?? '', // Default ke string kosong jika null
        state: widget.patientData['State'] ?? '', // Default ke string kosong jika null
        zipCode: widget.patientData['ZipCode'] ?? '', // Default ke string kosong jika null
        phoneNo: widget.patientData['PhoneNo'] ?? '', // Default ke string kosong jika null
        email: (widget.patientData['Email'] != null && widget.patientData['Email'].isNotEmpty)
            ? widget.patientData['Email']
            : 'dummy@com', // Default ke string kosong jika null
        guarantorID: 'ASURANSI',
        notes: 'mobile',
        birthPlace: widget.patientData['BirthPlace'] ?? ' ', // Default ke string kosong jika null
        sex: widget.patientData['Sex'] ?? 'M', // Default ke 'M' jika null
        ssn: widget.patientData['Ssn'] ?? ' ', // Default ke string kosong jika null
        mobilePhoneNo: widget.patientData['MobilePhone'] ?? ' ', // Default ke string kosong jika null
      );

      // Menampilkan pop-up konfirmasi sebelum membuat janji temu
      _showConfirmationPopup(appointmentRequest);

    } catch (e) {
      print('Error saat membuat AppointmentRequest: $e');
    }
  }

// Fungsi untuk menampilkan pop-up konfirmasi
  void _showConfirmationPopup(AppointmentRequest appointmentRequest) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Appointment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Apakah Anda yakin ingin membuat janji temu dengan detail berikut?'),
              SizedBox(height: 10),
              Text('Nama Pasien: ${appointmentRequest.firstName} ${appointmentRequest.middleName} ${appointmentRequest.lastName}'),
              Text('Dokter: $selectedDoctorName'),
              Text('Poli: $selectedPoliName'),
              Text('Tanggal Appointment: ${appointmentRequest.appointmentDate}'),
              Text('Waktu: ${appointmentRequest.appointmentTime}'),
              SizedBox(height: 20),
              Text('Klik "Ya" untuk melanjutkan atau "Tidak" untuk membatalkan.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Tidak'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Tutup dialog
                // Lanjutkan membuat appointment
                await _confirmAppointment(appointmentRequest);
              },
              child: Text('Ya'),
            ),
          ],
        );
      },
    );
  }

// Fungsi untuk konfirmasi dan mengirim appointment setelah user menekan "Ya"
  Future<void> _confirmAppointment(AppointmentRequest appointmentRequest) async {
    try {
      final apiService = ApiService(); // Pastikan ApiService diinisialisasi
      final appointmentRepository = AppointmentRepositoryImpl(apiService);
      final createAppointmentUseCase = CreateAppointmentUseCase(appointmentRepository);
      // Menggunakan UseCase untuk membuat appointment dan mendapatkan respons
      final result = await createAppointmentUseCase.execute(appointmentRequest);
      Map<String, dynamic> resultJson = json.decode(result);

      print(resultJson);
      print('ini hasil');
      // Menampilkan pop-up berdasarkan hasil respons
      if (resultJson['data'] == 'Appointment slot is full') {
        print('Jadwal sudah penuh');
        _showResultDialog(
          title: 'Gagal Membuat Appointment',
          content: 'Jadwal sudah penuh atau jam tidak ditemukan.',
        );
      } else {
        String appointmentNo = resultJson['data']['AppointmentNo'] ?? 'N/A';
        String appointmentQue = resultJson['data']['AppointmentQue'] ?? 'N/A';

        _showResultDialog(
          title: 'Appointment Berhasil Dibuat',
          content: 'Appointment Anda berhasil dibuat.\n'
              'Nomor Appointment: $appointmentNo\n'
              'Nomor Antrian: $appointmentQue',
        );
      }
    } catch (e) {
      _showResultDialog(
        title: 'Error',
        content: 'Terjadi kesalahan saat membuat appointment.$e',
      );
    }
  }
  // Fungsi untuk menampilkan pop-up hasil appointment
  void _showResultDialog({required String title, required String content}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [ 
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


}
