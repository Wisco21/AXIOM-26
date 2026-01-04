import 'package:axiom/providers/focus_provider.dart';
import 'package:axiom/screens/focus_home_screen.dart';
import 'package:axiom/screens/focus_ledger_screen.dart';
import 'package:axiom/screens/mind_change_screen.dart';
import 'package:axiom/screens/rule_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    RulesScreen(),
    PerspectiveChangeScreen(),
    FocusHomeScreen(),
    LedgerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final focusProvider = context.watch<FocusProvider>();
    final canNavigate = !focusProvider.isChunkActive;

    return WillPopScope(
      onWillPop: () async => canNavigate,
      child: Scaffold(
        backgroundColor: const Color(0xFF000000),
        body: _screens[_currentIndex],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFF1A1A1A), width: 1)),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: canNavigate
                ? (index) => setState(() => _currentIndex = index)
                : null,
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
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Iconsax.clipboard, size: 24),
                ),
                label: 'RULES',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Iconsax.lamp_charge,
                  size: 24,
                  color: Colors.amber,
                ),
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Iconsax.lamp_charge, size: 24),
                ),
                label: 'PERSPECTIVE',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Iconsax.timer_1,
                  size: 24,
                  color: Colors.white,
                ),
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Iconsax.timer, size: 24),
                ),
                label: 'FOCUS',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Iconsax.document_text, size: 24),
                ),
                label: 'LEDGER',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
