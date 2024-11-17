import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:healthcare/views/ForgotPassword/Email_OTP.dart';

import 'package:healthcare/views/Resigtration/Login.dart';
import 'package:healthcare/views/widgets/custom_button.dart';
import 'package:healthcare/views/widgets/custom_textfield.dart';

EmailOTP myauth = EmailOTP();

class EmailResend extends StatefulWidget {
  const EmailResend({super.key});

  @override
  State<EmailResend> createState() => _EmailResendState();
}

class _EmailResendState extends State<EmailResend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Container(
                      child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  )),
                ),
                SizedBox(
                  height: 22.h,
                ),
                Container(
                  child: const Text(
                    "Reset Password",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Container(
                  child: const Text(
                    "Enter your email, we will send a verification code to email",
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(177, 177, 177, 1)),
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                CustomTextfield(
                  text: "Type your email ",
                  controller: emailController,
                  prefixIcons: const Icon(Icons.email_outlined),
                ),
              ],
            ),
            CustomButton(
                text: "Send Code",
                onPressed: () async {
                  myauth.setConfig(
                      appEmail: "me@rohitchouhan.com",
                      appName: "Email OTP",
                      userEmail: emailController.text,
                      otpLength: 4,
                      otpType: OTPType.digitsOnly);
                  if (await myauth.sendOTP() == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Email_OTP()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("OTP has been sent"),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Oops, OTP send failed"),
                    ));
                  }
                })
          ],
        ),
      ),
    );
  }
}
