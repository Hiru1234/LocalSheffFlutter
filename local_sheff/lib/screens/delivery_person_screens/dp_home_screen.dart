import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_sheff/screens/delivery_person_screens/dp_account_screen.dart';
import 'package:local_sheff/screens/delivery_person_screens/dp_browse_screen.dart';

import '../../reusable_widgets/reusable_widget.dart';

class DpHomeScreen extends StatefulWidget {
  const DpHomeScreen({Key? key}) : super(key: key);

  @override
  State<DpHomeScreen> createState() => _DpHomeScreenState();
}

class _DpHomeScreenState extends State<DpHomeScreen> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    DpBrowseScreen(),
    DpAccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        unselectedItemColor: standardGreyColor,
        selectedItemColor: standardGreenColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          )
        ],
      ),
    );
  }
}
