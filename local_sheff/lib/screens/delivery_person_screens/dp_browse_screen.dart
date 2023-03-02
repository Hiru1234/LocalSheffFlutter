import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:local_sheff/screens/start_screen.dart';

class DPHomePage extends StatefulWidget {
  const DPHomePage({super.key});

  @override
  State<DPHomePage> createState() => _DPHomePageState();
}

class _DPHomePageState extends State<DPHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("Logout of delivery person"),
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