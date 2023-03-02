import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:local_sheff/reusable_widgets/reusable_widget.dart';

class CusCartScreen extends StatefulWidget {
  const CusCartScreen({super.key});

  @override
  State<CusCartScreen> createState() => _CusCartScreenState();
}

class _CusCartScreenState extends State<CusCartScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Cart Page"),
    );
  }
}