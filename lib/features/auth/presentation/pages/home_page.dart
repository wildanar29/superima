import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import carousel slider package
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Import smooth_page_indicator package
import '../../domain/usecases/get_patient_usecase.dart';
import '../../domain/entities/patient.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Untuk BlocProvider
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/appointment_repository_impl.dart'; // Tambahkan repository untuk appointment
import '../../../../core/network/api_service.dart';
import '../../domain/usecases/get_appointment_usecase.dart';
import 'package:mobile_rsi/features/auth/presentation/bloc/auth_bloc.dart'; // Untuk AuthBloc
import 'package:mobile_rsi/features/auth/presentation/bloc/auth_event.dart';
import 'package:mobile_rsi/features/auth/presentation/pages/pendaftaran_page.dart';
import 'package:mobile_rsi/features/auth/presentation/pages/penambahan_peserta_page.dart';
import 'profile_page.dart'; // Import halaman profil
import 'package:mobile_rsi/features/auth/presentation/pages/tiket_saya_page.dart'; // Import TiketSayaPage
import 'riwayat_berobat_page.dart'; // Import halaman Riwayat Berobat
import 'jadwal_dokter_page.dart';
import 'cek_kamar_page.dart'; // Import halaman Cek Kamar
import 'resep_saya_page.dart'; // Import halaman Resep Saya
import 'kritik_saran_page.dart'; // Import halaman Kritik & Saran
import 'penunjang_medis_page.dart'; // Import halaman Penunjang Medis
import 'package:url_launcher/url_launcher.dart'; // Import package url_launcher
import 'penunjang_medis_page.dart'; // Import halaman Penunjang Medis

class HomePage extends StatefulWidget {
  final GetPatientUsecase getPatientUsecase;

  // Konstruktor menerima getPatientUsecase
  HomePage({required this.getPatientUsecase});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // To keep track of the current index of the slider
  late GetAppointmentsUseCase getAppointmentsUseCase; // Tambahkan inisialisasi untuk GetAppointmentsUseCase

  @override
  void initState() {
    super.initState();
    // Inisialisasi GetAppointmentsUseCase dengan repository dan ApiService
    getAppointmentsUseCase =
        GetAppointmentsUseCase(AppointmentRepositoryImpl(ApiService()));
  }

  void _launchWhatsApp() async {
    const phoneNumber = "082120803478"; // Nomor WhatsApp
    final whatsappUrl = Uri.parse("https://wa.me/$phoneNumber"); // URL WhatsApp

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch $whatsappUrl";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil medicalNo yang dikirim dari LoginPage, cek null
    final String? medicalNo = ModalRoute.of(context)?.settings.arguments as String?;

    //Komentar atau hapus blok pengecekan medicalNo
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
      'assets/promo1.jpeg',
      'assets/promo2.jpeg',
      'assets/promo3.jpeg',
      'assets/promo4.jpeg',
      'assets/promo5.jpeg',
      'assets/promo6.jpeg',
      'assets/promo7.jpeg',
      'assets/promo8.jpeg',
      'assets/promo9.jpeg',
      'assets/promo10.jpeg',
      'assets/promo11.jpeg',
      'assets/promo12.jpeg',
      'assets/promo13.jpeg',
    ];

    // Mengambil ukuran layar perangkat secara dinamis
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Spacer(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'IMMA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Immanuel Mobile Apps',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Image.asset(
              'assets/Rsi.png',
              height: 45,
            ),
          ],
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: FutureBuilder<Patient?>(
          future: widget.getPatientUsecase.execute(medicalNo),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.hasData && snapshot.data != null) {
              final patientData = snapshot.data!;
              return ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text(
                      '${patientData.firstName}',
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Logout'),
                            content: Text('Are you sure you want to logout?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
                                  Navigator.of(context).pop();
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
        future: widget.getPatientUsecase.execute(medicalNo),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data != null) {
            final patientData = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Selamat Datang, ${patientData.firstName} ${patientData.middleName} ${patientData.lastName}',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: Image.asset(
                            'assets/Peserta.png',
                            width: 40,
                            height: 40,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PenambahanPesertaPage(
                                  patientData: patientData.toJson(),
                                  authRepository: AuthRepositoryImpl(),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
                    child: Container(
                      width: screenWidth,
                      color: Colors.white,
                      child: Column(
                        children: [
                          GridView.count(
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(20),
                            children: [
                              _buildMenuButton('assets/Pendaftaran.png', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PendaftaranPage(
                                      patientData: patientData.toJson(),
                                      authRepository: AuthRepositoryImpl(),
                                    ),
                                  ),
                                );
                              }),
                              _buildMenuButton('assets/RiwayatObat.png', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RiwayatBerobatPage(
                                      patientData: patientData.toJson(),
                                    ),
                                  ),
                                );
                              }),
                              _buildMenuButton('assets/JadwalDokter.png', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => JadwalDokterPage()),
                                );
                              }),
                              _buildMenuButton('assets/CekKamar.png', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CekKamarPage()),
                                );
                              }),
                              _buildMenuButton('assets/ResepSaya.png', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ResepSayaPage()),
                                );
                              }),
                              _buildMenuButton('assets/KritikSaran.png', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => KritikSaranPage()),
                                );
                              }),
                              _buildMenuButton('assets/TiketSaya.png', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TiketSayaPage(
                                      patientData: patientData.toJson(),
                                      authRepository: AuthRepositoryImpl(),
                                      getAppointmentsUseCase: getAppointmentsUseCase,
                                    ),
                                  ),
                                );
                              }),
                              _buildMenuButton('assets/WA.png', () {
                                _launchWhatsApp();
                              }),
                              _buildMenuButton('assets/Pendaftaran.png', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PenunjangMedisPage(),
                                  ),
                                );
                              }),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.3,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: screenHeight * 0.3,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 8),
                                autoPlayAnimationDuration: Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                onPageChanged: (index, reason) {
                                  _currentIndex = index;
                                },
                              ),
                              items: imgList.map((item) => GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                                    return DetailScreen(imagePath: item);
                                  }));
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      item,
                                      fit: BoxFit.cover,
                                      width: screenWidth * 0.9,
                                      height: screenHeight * 0.3,
                                    ),
                                  ),
                                ),
                              )).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(child: Text('No patient data found.'));
        },
      ),
    );
  }

  Widget _buildMenuButton(String imagePath, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Image.asset(
          imagePath,
          width: 100,
          height: 100,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String imagePath;

  DetailScreen({required this.imagePath});

  void _launchWhatsApp() async {
    const phoneNumber = "6282120803478"; // Nomor WhatsApp
    final whatsappUrl = Uri.parse("https://wa.me/$phoneNumber"); // URL WhatsApp

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch $whatsappUrl";
    }
  }


  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: imagePath,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  width: screenWidth,
                  height: screenHeight,
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tertarik?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    _launchWhatsApp();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/waLogo.png',
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Hubungi Kami',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
