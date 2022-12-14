import 'package:flutter/material.dart';
import 'package:patient_app/pages/home_page.dart';
import 'package:patient_app/pages/login_page.dart';
import 'package:patient_app/pages/google_map_page.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Patient Application',
      home : LoginPage(),
    );
  }
}
