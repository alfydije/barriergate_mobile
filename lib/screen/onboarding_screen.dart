import 'package:flutter/material.dart';
import 'package:ta_mobile/widget/q_button.dart';
import 'login/login_screen.dart'; // Ganti dengan nama file dan kelas layar onboarding Anda

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Atur latar belakang menjadi putih
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar di tengah layar
            Image.asset(
              'assets/onboarding.jpg', // Ganti dengan path gambar Anda
              width: 350, // Atur lebar gambar sesuai kebutuhan Anda
            ),
            const SizedBox(height: 20), // Spasi antara gambar dan teks
            // Teks di bawah gambar
            const Text(
              'Sistem Monitoring Parkir',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sebuah sistem yang menyediakan informasi dan laporan terkait data parkir di kampus Politeknik Negeri Indramayu',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
              textAlign: TextAlign.center, // Atur teks menjadi pusat
            ),

            const SizedBox(height: 20), // Spasi antara teks dan tombol
            // Tombol di bagian bawah
            QButton(
                  onPressed: () {
                    Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
                  },
                  text: 'Selanjutnya',
                ),
          ],
        ),
      ),
    );
  }
}

                
