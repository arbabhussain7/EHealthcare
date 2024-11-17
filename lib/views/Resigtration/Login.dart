import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healthcare/connect.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/AIRecommendation/ai_recommendation.dart';
import 'package:healthcare/views/BottomNavBar/bottom_Navbar.dart';
import 'package:healthcare/views/ForgotPassword/Email_Reset.dart';
import 'package:healthcare/views/Resigtration/Signup.dart';
import 'package:http/http.dart' as http;
import 'package:healthcare/views/widgets/custom_button.dart';
import 'package:healthcare/views/widgets/custom_textfield.dart';

import '../../models/patient.dart';

// import 'package:healthcare/Home/home.dart';
var id;
var userName;
var email;

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

final emailController = TextEditingController();
final passwordController = TextEditingController();
final confirmpasswordController = TextEditingController();
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

/// Function to log in with Google

class _SigninState extends State<Signin> {
  int groupValue = -1;
  bool isSelectedClick = false;
  GlobalKey<FormState> key = GlobalKey();
  Future<User?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        print("Google Sign-In canceled by user");
        return null; // Return if the sign-in process is canceled
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // User information
        String? email = user.email;

        // Send the user email to your PHP server
        var url = Uri.parse(Api.googlesigin);
        var response = await http.post(url, body: {"email": email ?? ""});

        if (response.statusCode == 200) {
          // Decode the response
          var responseData = jsonDecode(response.body);

          if (responseData['status'] == 'User found') {
            // Print user ID, username, and email
            print("User found in MySQL");
            print("ID: ${responseData['id']}");
            print("Username: ${responseData['username']}");
            print("Email: ${responseData['email']}");
            id = responseData['id'];
            userName = responseData['username'];
            email = responseData['email'];
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Signed In as: ${user.displayName}')),
            );
          } else {
            print("User not found in MySQL");
          }
        } else {
          print("Failed to connect to PHP server");
        }

        print("Google Sign-In successful, User: ${user.displayName}");
        return user;
      }
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
    return null;
  }

  void attemptLogin(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter email and password')),
        );
        return;
      }

      final url = Uri.parse(Api.login);

      final response =
          await http.post(url, body: {'email': email, 'password': password});

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        Patient patient = Patient.fromJson(responseData);
        id = patient.id;
        userName = patient.username;
        email = patient.email;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Login successful')));
        if (groupValue == 0) {
          Get.to(const AiRecommendation());
        } else {
          Get.to(const BottomNavBar());
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed to load data')));
      }
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 90.h, left: 16.w),
                  child: Container(
                    child: Text("Welcome Back!",
                        style: GoogleFonts.urbanist(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: textColor)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.h, left: 20.w),
                  child: Container(
                    child: Text("Sign In to your account",
                        style: GoogleFonts.urbanist(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: greyColor)),
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: 335.w,
                        height: 48.h,
                        // color: Color.fromRGBO(233, 236, 242, 1),
                        decoration: BoxDecoration(
                            border: Border.all(color: silverColor)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: Image.asset("assets/images/Google.png"),
                              ),
                              SizedBox(width: 12.w),
                              GestureDetector(
                                  onTap: () async {
                                    User? user = await loginWithGoogle();
                                    if (user != null) {
                                      Get.to(const BottomNavBar());
                                    }
                                  },
                                  child: Text("Sign in with Google",
                                      style: GoogleFonts.urbanist(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: blackAccentColor),
                                      textAlign: TextAlign.center))
                            ]))),
                SizedBox(height: 24.h),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(child: Divider(color: silverColor)),
                          SizedBox(width: 4.w),
                          Text("OR",
                              style: GoogleFonts.montserrat(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: greyColor)),
                          SizedBox(width: 4.w),
                          const Expanded(child: Divider(color: silverColor))
                        ])),
                CustomTextfield(
                  controller: emailController,
                  text: "Type of your email",
                  prefixIcons: const Icon(Icons.email_outlined),
                  // icons: Icon(Icons.email
                  // ),
                ),
                CustomTextfield(
                  controller: passwordController,
                  prefixIcons: const Icon(Icons.lock_outline),
                  text: "Type your password",
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Your Password ";
                    }
                    return null;
                  },
                  suffixIcons: null,
                  secureText: true,
                  isPassword: true,
                  inputType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => const EmailResend());
                      },
                      child: Text(
                        "Forgot Password",
                        style: GoogleFonts.urbanist(
                            color: cyanColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 33.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: Text(
                    "Choose Your Service Access",
                    style: GoogleFonts.urbanist(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: greyColor),
                  ),
                ),
                SizedBox(
                  height: 22.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: RadioListTile(
                        value: 0,
                        groupValue: groupValue,
                        title: Text(
                          "Access Basic Services",
                          style: GoogleFonts.urbanist(
                            fontSize: 12.h,
                          ),
                        ),
                        onChanged: (newValue) =>
                            setState(() => groupValue = newValue!),
                        activeColor: cyanColor,
                        selected: false,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: RadioListTile(
                        value: 1,
                        groupValue: groupValue,
                        title: Text(
                          "Access Paid Services",
                          style: GoogleFonts.urbanist(
                            fontSize: 12.h,
                          ),
                        ),
                        onChanged: (newValue) =>
                            setState(() => groupValue = newValue!),
                        activeColor: cyanColor,
                        selected: false,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 32.h,
                ),
                CustomButton(
                  text: "Login",
                  onPressed: () {
                    if (groupValue == -1) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please select a service option')));
                    } else {
                      attemptLogin(
                          emailController.text, passwordController.text);
                    }
                  },
                ),
                SizedBox(
                  height: 30.h,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: const Text(
                              "Don’t have account?",
                              style: TextStyle(
                                  fontSize: 15, color: greyAccentColor),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => const SignUp());
                            },
                            child: Text(
                              "Sign Up",
                              style: GoogleFonts.urbanist(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: cyanColor),
                            ),
                          )
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
