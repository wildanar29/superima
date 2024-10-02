import 'package:flutter/material.dart';
import '../../domain/entities/patient.dart';

class ProfilePage extends StatelessWidget {
  final Patient patient;

  ProfilePage({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID pasien: ${patient.patientID}', style: TextStyle(fontSize: 18)),
            Text('No Rekam Medik: ${patient.medicalNo}', style: TextStyle(fontSize: 18)),
            Text('Nama Depan: ${patient.firstName}', style: TextStyle(fontSize: 18)),
            Text('Nama Belakang: ${patient.lastName}', style: TextStyle(fontSize: 18)),
            Text('Tanggal Lahir: ${patient.dateOfBirth}', style: TextStyle(fontSize: 18)),
            Text('Alamat: ${patient.streetName}', style: TextStyle(fontSize: 18)),
            Text('Kota: ${patient.city}', style: TextStyle(fontSize: 18)),
            Text('No Telepon: ${patient.phoneNo}', style: TextStyle(fontSize: 18)),
            Text('Penjamin: ${patient.guarantorID}', style: TextStyle(fontSize: 18)),
            Text('Jenis Kelamin: ${patient.sex}', style: TextStyle(fontSize: 18)),
            Text('Agama: ${patient.SRReligionName}', style: TextStyle(fontSize: 18)),
            Text('Pendidikan: ${patient.SREducationName}', style: TextStyle(fontSize: 18)),
            Text('Status: ${patient.SROccupationName}', style: TextStyle(fontSize: 18)),
            Text('Perkawinan: ${patient.SRMaritalStatusName}', style: TextStyle(fontSize: 18)),



          ],
        ),
      ),
    );
  }
}
