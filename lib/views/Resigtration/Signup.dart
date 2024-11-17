import 'dart:convert';
import 'dart:developer';

import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healthcare/connect.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/BottomNavBar/bottom_Navbar.dart';
import 'package:healthcare/views/ForgotPassword/Email_Reset.dart';
import 'package:healthcare/views/Resigtration/Login.dart';
import 'package:healthcare/views/Resigtration/OTP.dart';
import 'package:healthcare/views/widgets/custom_button.dart';
import 'package:healthcare/views/widgets/custom_textfield.dart';
import 'package:http/http.dart' as http;

final phoneController = TextEditingController();
final emailcontroller = TextEditingController();
final usernameController = TextEditingController();
final passwordcontroller = TextEditingController();

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SigninState();
}

class _SigninState extends State<SignUp> {
  bool? isChecked = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn =
      GoogleSignIn(scopes: ['email']); // Ensure scopes are correct

  /// Function to sign up with Google (same as sign-in, but intended for new users)
  Future<User?> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        print("Google Sign-Up canceled by user");
        return null; // Return if the sign-up process is canceled
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Check if user exists in Firebase Auth
      final List<String> signInMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(googleUser.email);

      if (signInMethods.isNotEmpty) {
        print("User already exists in Firebase Auth");
        // User already exists, treat this as an error or inform the user they already have an account
        return null;
      }

      // User does not exist in Firebase Auth, proceed with sign-up
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // User information
        String? username = user.displayName;
        String? email = user.email;

        // Send the user information to your PHP server
        var url = Uri.parse(Api.googlesignup);
        var response = await http.post(url,
            body: {"username": username ?? "", "email": email ?? ""});

        if (response.statusCode == 200) {
          // Decode the response
          var responseData = jsonDecode(response.body);

          if (responseData['status'] == 'User added successfully') {
            // Print user ID, username, and email
            print("User added to MySQL successfully");
            print("ID: ${responseData['id']}");
            print("Username: ${responseData['username']}");
            print("Email: ${responseData['email']}");
            id = responseData['id'];
            userName = responseData['username'];
            email = responseData['email'];
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Signed up as: ${user.displayName}')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Signed up as:  ${responseData['status']}')),
            );
            print("Failed to add user to MySQL: ${responseData['status']}");
          }
        } else {
          print("Failed to connect to PHP server");
        }

        print("Google Sign-Up successful, User: $username");
        return user;
      }
    } catch (e) {
      print("Error during Google Sign-Up: $e");
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 90.h, left: 16.w),
                child: Container(
                  child: Text("Welcome Back!",
                      style: GoogleFonts.urbanist(
                          fontSize: 24.sp,
                          color: textColor,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 20.w),
                child: Container(
                  child: Text("Create account and enjoy all services",
                      style: GoogleFonts.urbanist(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: greyColor)),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 45.h, left: 35.w),
                  child: Container(
                    width: 335.w,
                    height: 48.h,
                    // color: Color.fromRGBO(233, 236, 242, 1),
                    decoration:
                        BoxDecoration(border: Border.all(color: silverColor)),
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
                            User? user = await signUpWithGoogle();
                            if (user != null) {
                              Get.to(const BottomNavBar());
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'User already exists or canceled')),
                              );
                            }
                          },
                          child: Container(
                            child: Text(
                              "Sign in with Google",
                              style: GoogleFonts.urbanist(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: blackAccColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 18.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(child: Divider(color: silverColor)),
                    SizedBox(
                      width: 4.w,
                    ),
                    Text(
                      "OR",
                      style: GoogleFonts.montserrat(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: greyColor),
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    const Expanded(
                      child: Divider(color: silverColor),
                    ),
                  ],
                ),
              ),
              CustomTextfield(
                text: "Type your username",
                controller: usernameController,
                prefixIcons: const Icon(Icons.person_outlined),
              ),
              CustomTextfield(
                text: "Type your Phone",
                inputType: TextInputType.phone,
                controller: phoneController,
                prefixIcons: const Icon(Icons.phone),
              ),
              CustomTextfield(
                text: "Type your email",
                controller: emailcontroller,
                prefixIcons: const Icon(Icons.email_outlined),
              ),
              CustomTextfield(
                controller: passwordcontroller,
                text: "Type your password",
                prefixIcons: const Icon(
                  Icons.lock_outline,
                  color: blackAccColor,
                ),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        value: isChecked,
                        activeColor: cyanColor,
                        onChanged: (newbool) {
                          setState(() {
                            isChecked = newbool;
                          });
                        }),
                    Row(
                      children: [
                        Text(
                          "I agree to the company",
                          style: GoogleFonts.urbanist(
                              color: greyColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          "Term and condition",
                          style: GoogleFonts.urbanist(
                              color: cyanColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
              CustomButton(
                text: "Sign Up",
                onPressed: () async {
                  Map<String, dynamic> data = {
                    "name": usernameController.text,
                    "username": usernameController.text,
                    "email": emailcontroller.text,
                    "phone": phoneController.text,
                    "password": passwordcontroller.text,
                  };

                  log(data.toString());
                  final response = await http.post(Uri.parse(Api.signup),
                      // headers: {'Content-Type': 'application/json'},
                      body: data);

                  if (response.statusCode == 200) {
                    final responseData = json.decode(response.body);
                    if (responseData['status'] == 'success') {
                      myauth.setConfig(
                          appEmail: "me@rohitchouhan.com",
                          appName: "Email OTP",
                          userEmail: emailcontroller.text,
                          otpLength: 4,
                          otpType: OTPType.digitsOnly);
                      Get.to(() => const OTPAddress());
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("OTP has been sent")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(responseData['message'])));
                      log(responseData.toString());
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Something went wrong')));
                    log(response.body.toString());
                  }

                  // if (await myauth.sendOTP() == true) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const OTPAddress()),
                  //   );
                  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //     content: Text("OTP has been sent"),
                  //   ));
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //     content: Text("Oops, OTP send failed"),
                  //   ));
                  // }
                },
              ),
              SizedBox(
                height: 32.h,
              ),
              Container(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    child: Text(
                      "Have an account?",
                      style: GoogleFonts.urbanist(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: greyColor),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => const Signin());
                    },
                    child: Text(
                      "Sign In",
                      style: GoogleFonts.urbanist(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: cyanColor),
                    ),
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
