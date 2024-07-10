import 'package:flutter/material.dart';
import 'package:barassage_app/features/admin_app/screens/home/home_screen.dart';

class HomeController extends StatefulWidget {
  const HomeController({super.key});

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
