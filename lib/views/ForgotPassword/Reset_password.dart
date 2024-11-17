import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:healthcare/connect.dart';
import 'package:healthcare/views/ForgotPassword/Verify_pass.dart';

import 'package:healthcare/views/Resigtration/Login.dart';
import 'package:healthcare/views/widgets/custom_button.dart';
import 'package:healthcare/views/widgets/custom_textfield.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> resetPassword(
    String email, String newPassword) async {
  final url = Uri.parse(Api.forget);

  final response = await http.post(
    url,
    body: {
      'email': email,
      'new_password': newPassword,
    },
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData;
  } else {
    // Error handling
    throw Exception('Failed to reset password');
  }
}

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  void attemptPasswordReset(String email, String newPassword) async {
    try {
      final response = await resetPassword(email, newPassword);

      if (response['status'] == 'success') {
        Get.to(() => const PasswordVerify());
        print('Password reset successful: ${response['message']}');
        // Proceed with navigation or other actions
      } else {
        print('Password reset failed: ${response['message']}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 18.h),
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
                    "New Password",
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
                    "Create a new password that is safe and easy to remember",
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(177, 177, 177, 1)),
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                CustomTextfield(
                  text: "New Password",
                  controller: passwordController,
                  prefixIcons: const Icon(Icons.lock_outline),
                ),
                CustomTextfield(
                    text: "Confirm New Password",
                    prefixIcons: const Icon(Icons.lock_outline),
                    controller: confirmpasswordController),
              ],
            ),
            CustomButton(
                text: "Continue",
                onPressed: () {
                  attemptPasswordReset(
                      emailController.text, passwordController.text);
                })
          ],
        ),
      ),
    );
  }
}
