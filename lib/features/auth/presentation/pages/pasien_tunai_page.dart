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
import 'package:http/http.dart' as http;  // Import http package
import 'payment_page.dart';
class PendaftaranPasienTunaiPage extends StatefulWidget {
  final Map<String, dynamic> patientData;
  final AuthRepository authRepository;

  PendaftaranPasienTunaiPage({
    required this.patientData,
    required this.authRepository,
  });

  @override
  _PendaftaranPasienTunaiPageState createState() =>
      _PendaftaranPasienTunaiPageState();
}

class _PendaftaranPasienTunaiPageState
    extends State<PendaftaranPasienTunaiPage> {
  String? selectedName;
  String? selectedMedicalNo;
  String? selectedDoctorName;
  String? selectedDoctorId;
  String? selectedPoliName; // Untuk menyimpan nama poli klinik yang dipilih
  String? selectedPoliId; // Untuk menyimpan ID poli klinik terkait
  String? nominal;
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
  // Fungsi untuk mengambil data nominal dari API
  Future<Map<String, dynamic>> fetchNominal(String paramedicID, String serviceUnitID) async {
    final String url = 'http://103.165.218.182:8080/getNominal?paramedicid=$paramedicID&serviceunitid=$serviceUnitID';

    try {
      final response = await http.post(Uri.parse(url));
      print(response.body);
      if (response.statusCode == 200) {
        // Decode hasil respons API
        final decodedJson = json.decode(response.body);
        nominal = decodedJson['nominal'].toString();
        return decodedJson;
      } else {
        print('Failed to fetch nominal data: ${response.statusCode}');
        throw Exception('Failed to load nominal data');
      }
    } catch (e) {
      print('Error fetching nominal: $e');
      throw Exception('Error fetching nominal');
    }
  }

  Future<String> _proceedToPayment() async {
    String backendUrl = 'http://10.200.200.20:8080/api/payment';
    var response = await http.post(
      Uri.parse(backendUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': nominal,
        'name': widget.patientData['FirstName'],
        'lastname': widget.patientData['LastName'],
        'phone': widget.patientData['PhoneNo'],
        'email': widget.patientData['Email'],
        'address': widget.patientData['StreetName'],
        'postcode': widget.patientData['ZipCode'],
        'state': widget.patientData['State'],
        'city': widget.patientData['City'],
        'country': widget.patientData['County'],
        'deviceToken': 'e1L8BlhHQ8-8Sm_qva3Bus:APA91bFDSPwpirOVHdRhlBcfr9vN-2gOmkvIs7R-n9Oe1k0QHSXZ1e91uNjjnmVIpZFm9PJzZjzQ1hU3G2TgOVEtihARsFJ1_Ocj_107fIBjeL9RukezpfmVLNXOqX_w0QyU1fn3UkKk',
      }),
    );
    Map<String, dynamic> payment = jsonDecode(response.body);
    Map<String, dynamic> responsePayment = payment['response'];
    Map<String, dynamic> getPayment = responsePayment['payment'];
    String url = getPayment['url'];
    return url;
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
          title: Text('Pendaftaran Rawat Jalan'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Tambahkan tombol back
            onPressed: () {
              Navigator.pop(context); // Kembali ke halaman sebelumnya
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
                                'Pilih Tanggal Pemeriksaan :',
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
                                        // selectedDoctorName = null;
                                        // selectedName = null;
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
                                        // selectedDoctorName = null; // Reset pilihan dokter
                                        selectedPoliName = null;
                                        // selectedName = null;
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
                              // Tambahkan logika di dalam onPressed tombol "Daftar Pemeriksaan"
                              ElevatedButton(
                                onPressed: (scheduleAvailable != null && scheduleAvailable == true)
                                    ? () async {
                                  if (selectedMedicalNo != null &&
                                      selectedPoliId != null &&
                                      selectedDoctorId != null &&
                                      selectedDate != null &&
                                      selectedName != null) {

                                    // Panggil API untuk mendapatkan nominal
                                    try {
                                      Map<String, dynamic> nominalData = await fetchNominal(selectedDoctorId!, selectedPoliId!);

                                      if (nominalData.containsKey('nominal')) {
                                        // Ambil nilai nominal dan format ke Rupiah
                                        double nominal = double.tryParse(nominalData['nominal'].toString()) ?? 0.0;
                                        String formattedNominal = NumberFormat.currency(
                                            locale: 'id',
                                            symbol: 'Rp ',
                                            decimalDigits: 0
                                        ).format(nominal);

                                        // Tampilkan pop-up dengan data dokter, poli, dan nominal
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Konfirmasi Pemeriksaan'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('Dokter: $selectedDoctorName'),
                                                  Text('Poli: $selectedPoliName'),
                                                  Text('Nominal: $formattedNominal'),  // Tampilkan nominal dalam format Rupiah
                                                  SizedBox(height: 20),
                                                  Text('Apakah Anda ingin melanjutkan ke pembayaran?'),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(); // Tutup dialog tanpa melanjutkan
                                                  },
                                                  child: Text('Tidak'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(); // Tutup dialog dan lanjut ke pembayaran
                                                    createRegistration(); // Panggil fungsi untuk melanjutkan ke pembayaran
                                                  },
                                                  child: Text('Ya, Lanjutkan'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        // Jika tidak ada nominal, tampilkan pesan kesalahan
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Nominal tidak ditemukan untuk kombinasi ini')),
                                        );
                                      }
                                    } catch (e) {
                                      // Tangani error jika API gagal
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Gagal mengambil nominal: $e')),
                                      );
                                    }
                                  } else {
                                    // Tampilkan pesan jika ada data yang belum dipilih
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Pastikan semua data sudah dipilih')),
                                    );
                                  }
                                }
                                    : null, // Tombol dinonaktifkan jika jadwal tidak tersedia atau belum dicek
                                child: Text('Daftar Pemeriksaan'),
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
              print('diatas');
              print(uniqueParamedics);
              print('dibawah');

              return DropdownButton<String>(
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

              return DropdownButton<String>(
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

              return DropdownButton<String>(
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


  Future<void> createRegistration() async {
    String url = await _proceedToPayment();
    final Uri paymentUrl = Uri.parse(url);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentPage(url: paymentUrl)),
    );
    // Data yang akan dikirim sebagai query parameters (diubah jadi string JSON)
    final Map<String, dynamic> registrationData = {
      "Patient": {
        "PatientID": widget.patientData['PatientID']
      },
      "ServiceUnitID": selectedPoliId,
      "ParamedicID": selectedDoctorId,
      "ExternalQueNo": "A-001",
      "ResponsiblePerson": {
        "NameOfTheResponsible": "",
        "SRRelationship": "",
        "SROccupation": "",
        "HomeAddress": "",
        "PhoneNo": ""
      },
      "EmergencyContact": {
        "ContactName": "",
        "SRRelationship": "",
        "StreetName": "Jl.Pancasila",
        "District": "",
        "City": "",
        "County": "",
        "State": "",
        "ZipCode": "",
        "PhoneNo": ""
      }
    };

    // Ubah Map ke JSON string
    final String jsonString = jsonEncode(registrationData);

    // URL untuk API pendaftaran, sertakan JSON string sebagai parameter
    final String urlRegistration = 'http://10.10.10.5/test3/WebService/V1_1/RegistrationWS.asmx/RegistrationCreate?AccessKey=AvcMblPat&JsonString=$jsonString';

    // Lakukan request GET ke API
    try {
      final response = await http.get(
        Uri.parse(urlRegistration), // Buat URI yang valid dari string URL
      );

      // Debug responsenya
      String responseBody = response.body;
      Map<String, dynamic> jsonData = jsonDecode(responseBody);
      Map<String, dynamic> dataRegistration = jsonData['data'];
      if (jsonData['status'] == 'OK') {
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: Text('Registrasi Berhasil'),
        //       content: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: <Widget>[
        //           Text('No Registrasi: ${dataRegistration['RegistrationNo']}'),
        //           Text('Unit Pelayanan: ${dataRegistration['ServiceUnitName']}'),
        //           Text('Dokter: ${dataRegistration['ParamedicName']}'),
        //         ],
        //       ),
        //       actions: <Widget>[
        //         TextButton(
        //           onPressed: () {
        //             Navigator.of(context).pop(); // Menutup dialog
        //           },
        //           child: Text('OK'),
        //         ),
        //       ],
        //     );
        //   },
        // );
        print('berhasil');
      }
      // Periksa status responsenya
      if (response.statusCode == 200) {
        // Parsing respon jika berhasil
        final responseData = jsonDecode(response.body);
        print('Registration successful: $responseData');
      } else {
        // Jika gagal, tampilkan pesan error
        print('Registration failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Tangani error request
      print('Error during registration: $e');
    }
  }



// Fungsi untuk menampilkan pop-up konfirmasi

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
        print('Appointment berhasil dibuat dengan No: $appointmentNo, Que: $appointmentQue');
      }
    } catch (e) {
      print('Error saat membuat AppointmentRequest: $e');
      _showResultDialog(
        title: 'Error',
        content: 'Terjadi kesalahan saat membuat appointment.',
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
