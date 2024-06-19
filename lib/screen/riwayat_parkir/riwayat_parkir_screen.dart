// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widget/q_appbar.dart';
import '../../widget/button.dart';
import '../../widget/q_box.dart';
import '../../view_models/riwayat_parkir_view_model.dart';
import '../homepage/hompage_screen.dart';

class RiwayatParkirPage extends StatelessWidget {
  const RiwayatParkirPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RiwayatParkirViewModel(),
      child: Scaffold(
        appBar: const QAppBar(title: 'Riwayat Parkir'),
        body: Consumer<RiwayatParkirViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Button(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            );
                          },
                          text: 'Semua',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Button(
                          onPressed: () {
                            // Do something when button is pressed
                          },
                          text: 'Rentang Waktu',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: viewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : viewModel.errorMessage != null
                          ? Center(
                              child: Text("Error: ${viewModel.errorMessage}"))
                          : viewModel.riwayatParkirList.isEmpty
                              ? const Center(
                                  child: Text("Riwayat parkir kosong."))
                              : ListView.builder(
                                  itemCount: viewModel.riwayatParkirList.length,
                                  itemBuilder: (context, index) {
                                    final riwayat =
                                        viewModel.riwayatParkirList[index];
                                    return QBox(
                                      tanggal: riwayat.tanggal,
                                      waktuMasuk: riwayat.waktuMasuk,
                                      waktuKeluar: riwayat.waktuKeluar,
                                    );
                                  },
                                ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
