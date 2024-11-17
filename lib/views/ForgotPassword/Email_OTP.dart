import 'dart:async';

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/ForgotPassword/Email_Reset.dart';
import 'package:healthcare/views/ForgotPassword/Reset_password.dart';
import 'package:healthcare/views/Resigtration/Login.dart';
import 'package:healthcare/views/widgets/custom_button.dart';
import 'package:pinput/pinput.dart';

class Email_OTP extends StatefulWidget {
  const Email_OTP({super.key});

  @override
  State<Email_OTP> createState() => _Email_OTPState();
}

class _Email_OTPState extends State<Email_OTP> {
  final TextEditingController otpController = TextEditingController();

  Future<void> verifyOTP() async {
    String otp = otpController.text;
    bool result = await myauth.verifyOTP(otp: otp);
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Verified Successfully!')),
      );
      onOtpVerified();
      Get.to(() => const ResetPassword());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP! Please try again.')),
      );
    }
  }

  int _start = 40; // The initial countdown time (40 seconds)
  Timer? _timer;
  bool _isOtpVerified = false;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_isOtpVerified) {
          // If OTP is verified, stop the timer
          _timer?.cancel();
        } else if (_start > 0) {
          _start--;
        } else {
          _timer?.cancel();
          resendOTP(); // Call the resendOTP function when the countdown reaches 0
        }
      });
    });
  }

// Call this function once the OTP is verified
  void onOtpVerified() {
    setState(() {
      _isOtpVerified = true;
    });
  }

  Future<void> resendOTP() async {
    myauth.setConfig(
        appEmail: "me@rohitchouhan.com",
        appName: "Email OTP",
        userEmail: emailController.text,
        otpLength: 4,
        otpType: OTPType.digitsOnly);
    if (await myauth.sendOTP() == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Email_OTP()),
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("OTP has been sent"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Oops, OTP send failed"),
      ));
    }
    print("OTP resent!");
  }

  @override
  void dispose() {
    otpController.dispose();
    _timer
        ?.cancel(); // Make sure to cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 12.h, right: 313.w),
                child: Container(
                    child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 122, right: 192),
              child: Container(
                child: const Text(
                  "Verify Code!",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
              child: RichText(
                  text: TextSpan(
                      text: "Please enter the code we just sent to email",
                      style: GoogleFonts.urbanist(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: greyColor),
                      children: <TextSpan>[
                    TextSpan(
                        text: " ${emailController.text}",
                        style: GoogleFonts.urbanist(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor))
                  ])),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 27, right: 225),
              child: Container(
                child: const Text(
                  "Verification Code",
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: 33.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 43.w),
              child: Pinput(
                controller: otpController,
                focusedPinTheme: PinTheme(
                    height: 50.0,
                    width: 50.0,
                    textStyle: GoogleFonts.urbanist(
                        fontSize: 20.sp,
                        color: textColor,
                        fontWeight: FontWeight.w700),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: whiteColor,
                      border: Border.all(color: cyanColor),
                    )),
                length: 4,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                defaultPinTheme: PinTheme(
                    height: 50.0,
                    width: 50.0,
                    textStyle: GoogleFonts.urbanist(
                        fontSize: 20.sp,
                        color: textColor,
                        fontWeight: FontWeight.w700),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: fillColor.withOpacity(0.1),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 63),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text(
                        "Resend code in",
                        style: TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(139, 139, 139, 1)),
                      ),
                    ),
                    Container(
                      child: Text(
                        "$_start",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 25),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 250.h,
            ),
            CustomButton(
                text: 'Continue',
                onPressed: () async {
                  await verifyOTP();
                })
          ],
        ),
      ),
    );
  }
}
