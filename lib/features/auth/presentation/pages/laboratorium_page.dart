import 'package:flutter/material.dart';

class LaboratoriumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laboratorium'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              'Ini adalah halaman Laboratorium',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          SizedBox(height: 40.0), // Jarak antara teks dan tombol
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Aksi untuk tombol Daftar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tombol Daftar ditekan')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text(
                'Daftar',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
          SizedBox(height: 16.0), // Jarak antara tombol
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Aksi untuk tombol Lihat Hasil
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tombol Lihat Hasil ditekan')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text(
                'Lihat Hasil',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
