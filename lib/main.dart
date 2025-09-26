import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'constants/app_constants.dart';
import 'controllers/report_controller.dart';
import 'screens/city_issues_screen.dart';
import 'screens/report_issue_screen.dart';
import 'screens/my_reports_screen.dart';

void main() {
  Get.put(ReportController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'City Care',
      theme: ThemeData(
        primaryColor: AppConstants.primaryBlue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: AppConstants.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final screens = [
    const CityIssuesScreen(),
    ReportIssueScreen(),
    MyReportsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppConstants.orange,
        unselectedItemColor: AppConstants.lightGreen,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.public), label: 'City Issues'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Reports'),
        ],
      ),
    );
  }
}