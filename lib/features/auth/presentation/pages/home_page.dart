import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import carousel slider package
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Import smooth_page_indicator package
import '../../domain/usecases/get_patient_usecase.dart';
import '../../domain/entities/patient.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Untuk BlocProvider
import '../../data/repositories/auth_repository_impl.dart';
import 'package:mobile_rsi/features/auth/presentation/bloc/auth_bloc.dart'; // Untuk AuthBloc
import 'package:mobile_rsi/features/auth/presentation/bloc/auth_event.dart';
import 'package:mobile_rsi/features/auth/presentation/pages/pendaftaran_page.dart';
import 'package:mobile_rsi/features/auth/presentation/pages/penambahan_peserta_page.dart';
import 'profile_page.dart'; // Import halaman profil

class HomePage extends StatefulWidget {
  final GetPatientUsecase getPatientUsecase;

  // Konstruktor menerima getPatientUsecase
  HomePage({required this.getPatientUsecase});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // To keep track of the current index of the slider

  @override
  Widget build(BuildContext context) {
    // Ambil medicalNo yang dikirim dari LoginPage, cek null
    final String? medicalNo = ModalRoute.of(context)?.settings.arguments as String?;

    if (medicalNo == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: Center(
          child: Text('Medical No is missing.'),
        ),
      );
    }

    // List of images for the slider
    final List<String> imgList = [
      'assets/promo2.jpeg', // Path gambar iklan 1
      'assets/promo3.jpeg', // Path gambar iklan 2
      'assets/promo4.jpeg', // Path gambar iklan 3
    ];

    // Mengambil ukuran layar perangkat secara dinamis
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/Rsi.png', // Path logo yang disimpan di dalam assets
              height: 40, // Tinggi logo
            ),
            SizedBox(width: 10),
            Text('RS IMMANUEL BANDUNG'), // Nama rumah sakit
          ],
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu), // Ikon hamburger
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Membuka drawer ketika hamburger ditekan
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: FutureBuilder<Patient?>(
          future: widget.getPatientUsecase.execute(medicalNo), // Panggil getPatientUsecase
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.hasData && snapshot.data != null) {
              final patientData = snapshot.data!; // Data pasien dari snapshot

              return ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text(
                      '${patientData.firstName}', // Menampilkan nama pasien
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(patient: patientData),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () {
                      // Menampilkan popup konfirmasi logout
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Logout'),
                            content: Text('Are you sure you want to logout?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Tutup dialog tanpa logout
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Memanggil event logout melalui Bloc
                                  BlocProvider.of<AuthBloc>(context).add(LogoutEvent());

                                  // Menavigasi kembali ke halaman login setelah logout berhasil
                                  Navigator.of(context).pop(); // Tutup dialog
                                  Navigator.pushReplacementNamed(context, '/');
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            }

            return Center(child: Text('No patient data found.'));
          },
        ),
      ),
      body: FutureBuilder<Patient?>(
        future: widget.getPatientUsecase.execute(medicalNo), // Panggil getPatientUsecase
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data != null) {
            final patientData = snapshot.data!; // Data pasien dari snapshot
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Selamat Datang, ${patientData.firstName} ${patientData.middleName} ${patientData.lastName}', // Menampilkan nama pasien
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), // Sesuaikan jarak dengan tinggi layar
                // Slider container
                SizedBox(
                  height: screenHeight * 0.25, // Sesuaikan slider dengan tinggi layar
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: screenHeight * 0.25,
                      autoPlay: false, // Slider tidak akan otomatis bergeser
                      enlargeCenterPage: true, // Gambar di tengah akan lebih besar
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index; // Update current index
                        });
                      },
                    ),
                    items: imgList.map((item) => Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          item,
                          fit: BoxFit.cover,
                          width: screenWidth * 0.9, // Sesuaikan dengan lebar layar
                        ),
                      ),
                    )).toList(),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), // Sesuaikan jarak
                // Smooth Page Indicator
                AnimatedSmoothIndicator(
                  activeIndex: _currentIndex,
                  count: imgList.length,
                  effect: WormEffect(
                    dotWidth: screenWidth * 0.03, // Sesuaikan ukuran dot dengan lebar layar
                    dotHeight: screenHeight * 0.015, // Sesuaikan ukuran dot dengan tinggi layar
                    activeDotColor: Colors.blue,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03), // Jarak antar komponen
                // 3 Buttons for navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          // Kirim data pasien ke PendaftaranPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PendaftaranPage(patientData: patientData.toJson(),authRepository: AuthRepositoryImpl()),
                            ),
                          );
                        },
                        child: Text('Pendaftaran'),
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/riwayatBerobat');
                        },
                        child: Text('Riwayat Berobat'),
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/jadwalDokter');
                        },
                        child: Text('Jadwal Dokter'),
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          // Kirim data pasien ke PendaftaranPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PenambahanPesertaPage(patientData: patientData.toJson(),authRepository: AuthRepositoryImpl()),
                            ),
                          );
                        },
                        child: Text('Penambahan Peserta'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }

          return Center(child: Text('No patient data found.'));
        },
      ),
    );
  }
}
