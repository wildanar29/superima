import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_rsi/features/auth/domain/repositories/auth_repository.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../domain/entities/user.dart';

class PenambahanPesertaPage extends StatefulWidget {
  final Map<String, dynamic> patientData;
  final AuthRepository authRepository;

  PenambahanPesertaPage({required this.patientData, required this.authRepository});

  @override
  _PenambahanPesertaPageState createState() => _PenambahanPesertaPageState();
}

class _PenambahanPesertaPageState extends State<PenambahanPesertaPage> {
  late Future<String?> futureNoKK;
  String? noKKFromAPI;

  // Controllers untuk setiap input field
  TextEditingController noKKController = TextEditingController();
  TextEditingController nikController = TextEditingController();
  TextEditingController medicalNoController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isNoKKMatched = false; // Menentukan apakah No KK sudah cocok

  @override
  void initState() {
    super.initState();
    // Panggil API untuk mendapatkan No KK dengan medicalNo
    final medicalNo = widget.patientData['MedicalNo'] ?? '';
    futureNoKK = widget.authRepository.getNoKKByMedicalNo(medicalNo);
  }

  void _checkNoKKMatch() {
    // Mengambil nilai input dari TextField
    String inputNoKK = noKKController.text;

    // Memeriksa apakah No KK yang dimasukkan cocok dengan No KK dari API
    if (inputNoKK == noKKFromAPI) {
      _showConfirmationDialog(); // Menampilkan popup jika No KK cocok
    } else {
      _showNoKKMismatchDialog(); // Menampilkan popup jika No KK tidak cocok
    }
  }

  // Menampilkan dialog konfirmasi jika No KK cocok
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi No KK"),
          content: Text("No KK ditemukan. Apakah ingin melanjutkan untuk menambahkan peserta?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
                setState(() {
                  isNoKKMatched = true; // Tampilkan input lainnya dan sembunyikan tombol Submit
                });
              },
              child: Text("Ya"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog tanpa menampilkan input lainnya
              },
              child: Text("Tidak"),
            ),
          ],
        );
      },
    );
  }

  // Menampilkan dialog error jika No KK tidak cocok
  void _showNoKKMismatchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Peringatan"),
          content: Text("No KK tidak sesuai!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  // Menampilkan dialog rekapan data yang diinput sebelum disimpan
  void _showRecapDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Data Peserta'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Berikut adalah data yang akan disimpan:'),
                SizedBox(height: 10),
                Text('NIK: ${nikController.text}'),
                Text('Medical No: ${medicalNoController.text}'),
                Text('Phone Number: ${phoneNumberController.text}'),
                Text('Email: ${emailController.text}'),
                Text('No KK: ${noKKController.text}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup popup jika pengguna batal menyimpan
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _proceedSignup(context); // Lanjutkan menyimpan data jika pengguna setuju
                Navigator.of(context).pop(); // Tutup dialog rekapan
              },
              child: Text('Konfirmasi'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk melanjutkan proses pendaftaran dan menyimpan data ke database
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Penambahan Peserta'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignupFailure) {
            print(state);
            _showFailureDialog(context, 'Pendaftaran Gagal', 'Silakan coba lagi.');
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // FutureBuilder untuk menampilkan hasil dari API No KK
                  // FutureBuilder<String?>(
                  //   future: futureNoKK,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return CircularProgressIndicator();
                  //     } else if (snapshot.hasError) {
                  //       return Text('Error: ${snapshot.error}');
                  //     } else if (snapshot.hasData) {
                  //       noKKFromAPI = snapshot.data; // Menyimpan No KK dari API
                  //       return Text(noKKFromAPI != null ? 'No KK dari API: $noKKFromAPI' : 'No KK tidak ditemukan');
                  //     } else {
                  //       return Text('No KK tidak tersedia.');
                  //     }
                  //   },
                  // ),
                  SizedBox(height: 20),
                  // TextField untuk memasukkan No KK
                  TextField(
                    controller: noKKController,
                    decoration: InputDecoration(
                      labelText: 'Masukkan No. KK',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Tampilkan tombol Submit No KK hanya jika No KK belum cocok
                  if (!isNoKKMatched)
                    ElevatedButton(
                      onPressed: _checkNoKKMatch, // Memeriksa kecocokan No KK saat tombol ditekan
                      child: Text('Submit No KK'),
                    ),
                  SizedBox(height: 20),
                  // Jika No KK cocok, tampilkan input lainnya
                  if (isNoKKMatched) ...[
                    TextField(
                      controller: nikController,
                      decoration: InputDecoration(
                        labelText: 'Masukkan NIK',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: medicalNoController,
                      decoration: InputDecoration(
                        labelText: 'Masukkan Medical No',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Masukkan Phone Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Masukkan Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Masukkan Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _showRecapDialog(context), // Menampilkan dialog rekapan data sebelum menyimpan
                      child: Text('Simpan Peserta'),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Fungsi untuk menampilkan popup sukses
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pendaftaran Berhasil'),
          content: Text('Data peserta berhasil disimpan.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // Kosongkan semua input field setelah berhasil menyimpan data
                _clearInputFields();
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk mengosongkan semua input field setelah pendaftaran berhasil
  void _clearInputFields() {
    noKKController.clear();
    nikController.clear();
    medicalNoController.clear();
    phoneNumberController.clear();
    emailController.clear();
    passwordController.clear();
    setState(() {
      isNoKKMatched = false; // Reset state No KK
    });
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
