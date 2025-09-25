import 'package:flutter/material.dart';
import 'package:nagrik/pages/city_search_page.dart';
import 'package:nagrik/pages/front_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: CitySearchPage()
    );
  }
}

