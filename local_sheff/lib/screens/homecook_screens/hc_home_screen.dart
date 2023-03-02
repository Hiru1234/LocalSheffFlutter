import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:local_sheff/screens/start_screen.dart';

class HCHomeScreen extends StatefulWidget {
  const HCHomeScreen({super.key});

  @override
  State<HCHomeScreen> createState() => _HCHomeScreenState();
}

class _HCHomeScreenState extends State<HCHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("Logout of homecook"),
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              print("Signed Out");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StartScreen()));
            });
          },
        ),
      ),
    );
  }
}