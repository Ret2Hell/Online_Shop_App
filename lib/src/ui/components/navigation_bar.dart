import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/src/config/constants.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _currentScreen = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentScreen,
        children: screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.yellow,
        items: navigationBarIcons,
        onTap: (value) {
          setState(() {
            _currentScreen = value;
          });
        },
      ),
    );
  }
}
