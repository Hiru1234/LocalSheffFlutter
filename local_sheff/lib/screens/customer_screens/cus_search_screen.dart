import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:local_sheff/reusable_widgets/reusable_widget.dart';

class CusSearchScreen extends StatefulWidget {
  const CusSearchScreen({super.key});

  @override
  State<CusSearchScreen> createState() => _CusSearchScreenState();
}

class _CusSearchScreenState extends State<CusSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text("Search Page"),
    );
  }
}