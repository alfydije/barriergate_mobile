// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:ta_mobile/models/user_model.dart';
import 'package:ta_mobile/screen/profil/edit_profile_screen.dart';
import '../../services/profil_service.dart';
import '../../widget/text_style.dart';
import '../../widget/button.dart';
import '../../widget/q_appbar.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final ProfileService _profileService = ProfileService();

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const QAppBar(title: 'Profil'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<User>(
          future: _profileService.fetchProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final user = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileHeader(user: user),
                    const SizedBox(height: 50),
                    ProfileSection(title: 'IDENTITAS', children: [
                      ProfileInfoRow(label: "Username", value: user.username!),
                      ProfileInfoRow(
                          label: "NIP / NIM", value: user.userProfile!.nipNim!),
                      ProfileInfoRow(
                          label: "Nama", value: user.userProfile!.name!),
                      ProfileInfoRow(
                          label: "Jenis Kelamin",
                          value: user.userProfile!.gender!),
                    ]),
                    const SizedBox(height: 30),
                    ProfileSection(title: 'INFO KONTAK', children: [
                      ProfileInfoRow(label: "Email", value: user.email!),
                      ProfileInfoRow(
                          label: "Nomor Hp",
                          value: user.userProfile!.phoneNumber!),
                      ProfileInfoRow(
                          label: "Alamat", value: user.userProfile!.address!),
                    ]),
                    const SizedBox(height: 70),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Button(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfil(user: user),
                                ),
                              );
                              setState(() {});
                            },
                            text: 'Edit Profile',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text("No data available"));
            }
          },
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final User user;

  const ProfileHeader({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(
              'https://bariergate.my.id/storage/${user.userProfile!.image!}'),
          radius: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.userProfile!.name!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text(user.username!, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileSection({Key? key, required this.title, required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ...children
            .map((child) => Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                  child: child,
                ))
            .toList(),
      ],
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoRow({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: QTextStyle.usernameStyle,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: QTextStyle.valueStyle,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
