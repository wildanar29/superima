import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_rsi/features/auth/domain/usecases/get_patient_usecase.dart';
import 'package:mobile_rsi/features/auth/presentation/pages/pendaftaran_page.dart';
import 'package:mobile_rsi/features/auth/presentation/pages/penambahan_peserta_page.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/home_page.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/repositories/patient_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/presentation/pages/pasien_mitra_page.dart';
import 'features/auth/presentation/pages/pasien_tunai_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'features/auth/presentation/pages/first_page.dart';

void main() async {
  // Inisialisasi Hive untuk penyimpanan data lokal
  await Hive.initFlutter();
  await Hive.openBox('myBox');

  // Inisialisasi repository dan use case
  final authRepository = AuthRepositoryImpl();
  final patientRepository = PatientRepositoryImpl();

  runApp(MyApp(authRepository: authRepository, patientRepository: patientRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final PatientRepositoryImpl patientRepository;

  MyApp({required this.authRepository, required this.patientRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            loginUseCase: LoginUseCase(authRepository),
            signupUseCase: SignupUseCase(authRepository),
            getPatientUsecase: GetPatientUsecase(patientRepository),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Clean Architecture',
        initialRoute: '/',
        routes: {
          '/first': (context) => FirstPage(), // Halaman pembuka (splash screen)
          '/': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
          '/home': (context) => HomePage(getPatientUsecase: GetPatientUsecase(patientRepository)),
          // '/pendaftaran': (context) => PendaftaranPage(patientData: patientRepository,),
          // '/pendaftaranPasienMitra': (context) => PendaftaranPasienMitraPage(),
          // '/pendaftaranPasienTunai': (context) => PendaftaranPasienTunaiPage(),
          // '/penambahanPeserta': (context) => PenambahanPesertaPage(),
        },
      ),
    );
  }
}


