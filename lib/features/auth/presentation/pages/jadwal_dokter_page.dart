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
        title: Text('Jadwal Dokter'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'BPJS'),
            Tab(text: 'Non-BPJS'),
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
