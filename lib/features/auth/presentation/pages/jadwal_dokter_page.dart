import 'package:flutter/material.dart';
import 'bpjs_tab.dart';
import 'non_bpjs_tab.dart';

class JadwalDokterPage extends StatefulWidget {
  @override
  _JadwalDokterPageState createState() => _JadwalDokterPageState();
}

class _JadwalDokterPageState extends State<JadwalDokterPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Dua tab: BPJS dan Non-BPJS
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Untuk menengahkan teks di AppBar
        title: Text(
          'Jadwal Dokter',
          style: TextStyle(
            fontSize: 24, // Ukuran teks lebih besar
            fontWeight: FontWeight.bold, // Membuat teks tebal
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios), // Menambahkan ikon panah kembali
          iconSize: 35, // Memperbesar ukuran ikon
          onPressed: () {
            Navigator.pop(context); // Aksi kembali ke halaman sebelumnya
          },
        ),
        bottom: TabBar(
        controller: _tabController,
        tabs: [
        Tab(
        child: Text(
        'BPJS',
        style: TextStyle(
        fontWeight: FontWeight.bold, // Membuat teks tebal
        fontSize: 18, // Mengubah ukuran teks
           ),
         ),
      ),
          Tab(
        child: Text(
        'Non-BPJS',
        style: TextStyle(
        fontWeight: FontWeight.bold, // Membuat teks tebal
        fontSize: 18, // Mengubah ukuran teks
             ),
            ),
           ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BPJSTab(), // Gunakan widget dari file bpjs_tab.dart
          NonBPJSTab(), // Gunakan widget dari file non_bpjs_tab.dart
        ],
      ),
    );
  }
}
