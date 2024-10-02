import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile_rsi/features/auth/domain/repositories/auth_repository.dart';
import '../../data/repositories/paramedic_repository_impl.dart';
import '../../domain/entities/paramedic.dart';
import '../../data/repositories/poliklinik_repository_impl.dart';
import '../../domain/entities/poliklinik.dart';
import '../../data/repositories/shedule_repository_impl.dart'; // Import repository jadwal

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
          } else {
            scheduleAvailable = false; // Tidak ada jadwal
          }
        });
      } catch (e) {
        print('Error checking schedule: $e');
        setState(() {
          scheduleAvailable = false; // Tidak ada jadwal
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
      selectedDoctorName = null; // Reset pilihan dokter
      _doctorsByPoliFuture = _getDoctorsByPoli(selectedPoliId!); // Ambil daftar dokter berdasarkan poli yang dipilih
    });
  }

  // Fungsi yang dipanggil ketika dokter dipilih
  Future<void> _onDoctorSelected(String? newValue, List<Paramedic> paramedics) async {
    setState(() {
      selectedDoctorName = newValue;
      selectedDoctorId = paramedics
          .firstWhere((doctor) => doctor.paramedicName == newValue)
          .paramedicID;
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
          title: Text('Pendaftaran Appointment'),
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
                              DropdownButton<String>(
                                hint: Text("Pilih Nama Pasien"),
                                value: selectedName,
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
                                child: Text(
                                  selectedDate != null
                                      ? '${DateFormat('yyyy-MM-dd').format(selectedDate!)}'
                                      : 'Pilih Tanggal',
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
                                children: [
                                  Radio<String>(
                                    value: 'dokter',
                                    groupValue: selectedOption,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedOption = value; // Pilih berdasarkan dokter
                                        selectedPoliName = null; // Reset pilihan poli
                                        selectedDoctorName = null;
                                      });
                                    },
                                  ),
                                  Text('Dokter'),
                                  Radio<String>(
                                    value: 'poli',
                                    groupValue: selectedOption,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedOption = value; // Pilih berdasarkan poli
                                        selectedDoctorName = null; // Reset pilihan dokter
                                        selectedPoliName = null;
                                      });
                                    },
                                  ),
                                  Text('Poli'),
                                ],
                              ),

                              SizedBox(height: 20),

                              // Tampilkan dropdown berdasarkan pilihan radio button
                              if (selectedOption == 'dokter') ...[
                                _buildDokterDropdown(),
                                SizedBox(height: 20),
                                if (selectedDoctorId != null) _buildPoliDropdownBasedOnDoctor()
                              ] else ...[
                                _buildAllPoliDropdown(),
                                SizedBox(height: 20),
                                if (selectedPoliId != null) _buildDoctorDropdownBasedOnPoli()
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
              return DropdownButton<String>(
                hint: Text("Pilih Dokter"),
                value: selectedDoctorName,
                onChanged: (String? newValue) async {
                  await _onDoctorSelected(newValue, paramedics);
                },
                items: paramedics
                    .map<DropdownMenuItem<String>>((Paramedic doctor) {
                  return DropdownMenuItem<String>(
                    value: doctor.paramedicName,
                    child: Text(doctor.paramedicName),
                  );
                }).toList(),
              );
            } else {
              return Text('Tidak ada dokter yang tersedia');
            }
          },
        ),
      ],
    );
  }

  // Dropdown untuk menampilkan poli berdasarkan dokter yang dipilih
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
          future: _poliKlinikFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data != null) {
              List<PoliKlinik> polikliniks = snapshot.data!;
              return DropdownButton<String>(
                hint: Text("Pilih Poli Klinik"),
                value: selectedPoliName,
                onChanged: (String? newValue) async {
                  await _onPoliSelected(newValue, polikliniks);
                },
                items: polikliniks
                    .map<DropdownMenuItem<String>>((PoliKlinik poli) {
                  return DropdownMenuItem<String>(
                    value: poli.serviceUnitName,
                    child: Text(poli.serviceUnitName), // Menampilkan serviceUnitName
                  );
                }).toList(),
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
              return DropdownButton<String>(
                hint: Text("Pilih Poli Klinik"),
                value: selectedPoliName,
                onChanged: (String? newValue) async {
                  await _onPoliSelected(newValue, polikliniks);
                },
                items: polikliniks
                    .map<DropdownMenuItem<String>>((PoliKlinik poli) {
                  return DropdownMenuItem<String>(
                    value: poli.serviceUnitName,
                    child: Text(poli.serviceUnitName), // Menampilkan serviceUnitName
                  );
                }).toList(),
              );
            } else {
              return Text('Tidak ada poli klinik yang tersedia');
            }
          },
        ),
      ],
    );
  }

  // Dropdown untuk menampilkan dokter berdasarkan poli yang dipilih
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
              print('masuk di error');
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data != null) {
              List<Paramedic> paramedics = snapshot.data!;
              return DropdownButton<String>(
                hint: Text("Pilih Dokter"),
                value: selectedDoctorName,
                onChanged: (String? newValue) async {
                  await _onDoctorSelected(newValue, paramedics);
                },
                items: paramedics
                    .map<DropdownMenuItem<String>>((Paramedic doctor) {
                  return DropdownMenuItem<String>(
                    value: doctor.paramedicID,
                    child: Text(doctor.paramedicName),
                  );
                }).toList(),
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
}
