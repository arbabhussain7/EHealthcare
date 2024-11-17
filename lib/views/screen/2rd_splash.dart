import 'package:flutter/material.dart';

class SecondSplash extends StatefulWidget {
  const SecondSplash({Key? key}) : super(key: key);

  @override
  State<SecondSplash> createState() => _SecondSplashState();
}

class _SecondSplashState extends State<SecondSplash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: 190,
                height: 120,
                child: Image.asset("Image/Logo.png"),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 150),
                  child: SizedBox(
                      height: 400,
                      width: 450,
                      child: Image.asset("Image/Splashimg.png")),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
