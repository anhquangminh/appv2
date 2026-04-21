import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/presentation/pages/duyet/duyet_screen.dart';
import 'package:ducanherp/presentation/pages/home/home_content.dart';
import 'package:ducanherp/presentation/pages/home/widgets/bottom_bar.dart';
import 'package:ducanherp/presentation/pages/home/widgets/home_app_bar.dart';
import 'package:ducanherp/presentation/pages/profile_page.dart';
import 'package:ducanherp/presentation/pages/quanlynhom/quanlynhom_page.dart';
import 'package:ducanherp/presentation/pages/test_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    HomeContent(),
    DuyetScreen(),
    QuanLyNhomPage(),
    TestPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: HomeAppBar(currentIndex: _currentIndex),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 20), // 👉 sát bottom
        child: SizedBox(
          width: 50,
          height: 50,
          child: FloatingActionButton(
            shape: const CircleBorder(), // 👉 đảm bảo hình tròn
            elevation: 6,
            backgroundColor: context.primary,
            onPressed: () {

            },
            child: Icon(Icons.add, size: 28, color: context.onPrimary),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
