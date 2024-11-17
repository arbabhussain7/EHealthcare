import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/Resigtration/Login.dart';

class PasswordVerify extends StatefulWidget {
  const PasswordVerify({super.key});

  @override
  State<PasswordVerify> createState() => _PasswordVerifyState();
}

class _PasswordVerifyState extends State<PasswordVerify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 136.w,
              height: 136.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(107.r),
                  color: whiteColor.withOpacity(0.3)),
              child: const Icon(
                Icons.check,
                color: whiteColor,
                size: 63,
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            Container(
              child: Text(
                "Password Changed",
                style: GoogleFonts.urbanist(
                    fontSize: 24.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            Center(
              child: Text(
                "Password changed successfully, you can login again with a new password",
                textAlign: TextAlign.center, // Set the text alignment to center
                style: GoogleFonts.urbanist(
                  fontSize: 16.sp,
                  color: softGreyColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              height: 332.h,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 334.w,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const Signin());
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(2.r), // button's shape
                    ),
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                    // text color
                    elevation: 5, // button's elevation when it's pressed
                  ),
                  child: Text(
                    "Sign In Now",
                    style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
