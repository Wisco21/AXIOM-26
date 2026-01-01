import 'package:axiom/screens/rule_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'mind_change_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    RulesScreen(),
    MindChangeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF1A1A1A), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: const Color(0xFF0A0A0A),
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color(0xFF666666),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 11,
            letterSpacing: 1,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11,
            letterSpacing: 1,
          ),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items:  [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Iconsax.clipboard, size: 24),
              ),
              label: 'RULES',
            ),
            BottomNavigationBarItem(
              activeIcon:  Icon(Iconsax.lamp_charge, size: 24, color: Colors.amber,),
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Iconsax.lamp_charge, size: 24,),
              ),
              label: 'MIND CHANGE',
            ),
          ],
        ),
      ),
    );
  }
}