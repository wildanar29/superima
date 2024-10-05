import 'package:flutter/material.dart';

class ResepSayaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resep Saya'),
      ),
      body: Center(
        child: Text(
          'Halaman Resep Saya',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
