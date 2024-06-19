// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/data_kendaraan.dart';
import '../../view_models/data_kendaraan_view_model.dart';
import '../../widget/q_appbar.dart';

class DataKendaraanPage extends StatelessWidget {
  const DataKendaraanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataKendaraanViewModel()..fetchData(),
      child: Scaffold(
        appBar: const QAppBar(title: 'Data Kendaraan'),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<DataKendaraanViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (viewModel.errorMessage != null) {
                return Center(child: Text('Error: ${viewModel.errorMessage}'));
              }

              if (viewModel.dataKendaraan.isEmpty) {
                return Center(child: Text('No data available'));
              }

              DataKendaraan kendaraan = viewModel.dataKendaraan.first;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 225, 238, 247),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            "http://10.0.164.127:8000/storage/${kendaraan.gambar}", // Gambar kendaraan dari JSON
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.error),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Merk: ${kendaraan.merk}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Tipe: ${kendaraan.tipe}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'No Kendaraan: ${kendaraan.noKendaraan}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
