import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profileprovider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ProfileProvider>(context, listen: false).fetchProfile());
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profile = profileProvider.profile;

    return Scaffold(
      appBar: AppBar(title: Text("My Profile")),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profile?['image']),
            ),
            SizedBox(height: 20),
            Text(
              "${profile?['firstName']} ${profile?['lastName']}",
              style:  TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Username: ${profile?['username']}"),
            SizedBox(height: 5),
            Text("Email: ${profile?['email']}"),
            SizedBox(height: 5),
            Text("Gender: ${profile?['gender']}"),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
