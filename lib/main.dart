import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey =
      'pk_test_51Q1nGrFHugyQIn2Jo2F4AJUICJQAYwhiZtrZZSab0MBvLUAIChcaTt8bvfQZTL0sqBpoUnq6evjsTeslbzWpwmBb00lQXUvOxN';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Ehealthcare',
            // You can use the library anywhere in the app even in theme
            theme: ThemeData(
              progressIndicatorTheme: const ProgressIndicatorThemeData(
                color: cyanColor,
              ),
              scaffoldBackgroundColor: whiteColor,
              primarySwatch: Colors.blue,
              primaryColor: cyanColor,
              textSelectionTheme: TextSelectionThemeData(
                  cursorColor: cyanColor,
                  selectionColor: cyanColor.withOpacity(0.5),
                  selectionHandleColor: cyanColor),
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            ),
            home: const SplashScreen());
      },
    );
  }
}
