import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import paket ikon FontAwesome
import 'laboratorium_page.dart'; // Import halaman Laboratorium

class PenunjangMedisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Penunjang Medis'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildMedicalSupportCard(
            context,
            title: 'Laboratorium',
            description: 'Layanan pemeriksaan laboratorium untuk berbagai jenis tes.',
            icon: FontAwesomeIcons.vial, // Ikon FontAwesome untuk laboratorium
            onTap: () {
              // Navigasi ke halaman Laboratorium ketika ditekan
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LaboratoriumPage()),
              );
            },
          ),
          SizedBox(height: 16.0),
          _buildMedicalSupportCard(
            context,
            title: 'Radiologi',
            description: 'Layanan pemeriksaan radiologi seperti X-Ray, CT Scan, dan MRI.',
            icon: FontAwesomeIcons.xRay, // Ikon FontAwesome untuk radiologi
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Radiologi ditekan')),
              );
            },
          ),
          SizedBox(height: 16.0),
          _buildMedicalSupportCard(
            context,
            title: 'CT-SCAN',
            description: 'Layanan pemeriksaan pencitraan medis menggunakan CT-Scan.',
            icon: FontAwesomeIcons.desktop, // Gunakan ikon yang sesuai
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('CT-SCAN ditekan')),
              );
            },
          ),
          SizedBox(height: 16.0),
          _buildMedicalSupportCard(
            context,
            title: 'USG',
            description: 'Layanan pemeriksaan USG untuk berbagai kebutuhan medis.',
            icon: FontAwesomeIcons.waveSquare, // Ikon yang lebih sesuai untuk USG
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('USG ditekan')),
              );
            },
          ),
          SizedBox(height: 16.0),
          _buildMedicalSupportCard(
            context,
            title: 'Endoskopi',
            description: 'Layanan pemeriksaan menggunakan endoskop untuk diagnosis.',
            icon: FontAwesomeIcons.eye, // Ikon yang lebih sesuai untuk endoskopi
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Endoskopi ditekan')),
              );
            },
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membuat kartu layanan penunjang medis
  Widget _buildMedicalSupportCard(
      BuildContext context, {
        required String title,
        required String description,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              FaIcon( // Gunakan FaIcon dari FontAwesome
                icon,
                size: 40.0,
                color: Colors.blueAccent,
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
