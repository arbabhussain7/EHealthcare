import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthcare/views/BottomNavBar/bottom_Navbar.dart';
import 'package:healthcare/views/Resigtration/Login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      FirebaseAuth.instance.currentUser == null
          ? Get.to(() => const Signin())
          : Get.offAll(() => const BottomNavBar());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
              Color.fromRGBO(131, 226, 255, 1),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 240, 229, 229),
            ])),
        child: Center(
          child: SizedBox(
            height: 321,
            width: 322,
            child: Image.asset("assets/images/Logo.png"),
          ),
        ),
      ),
    );
  }
}
