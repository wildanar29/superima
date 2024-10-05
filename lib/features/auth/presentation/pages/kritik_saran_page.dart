import 'package:flutter/material.dart';

class KritikSaranPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kritik & Saran'),
      ),
      body: Center(
        child: Text(
          'Halaman Kritik & Saran',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
