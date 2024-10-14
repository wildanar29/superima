import 'package:flutter/material.dart';


class BuktiBayarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bukti Bayar'),
      ),
      body: Center(
        child: Text(
          'Halaman Bukti Bayar',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}