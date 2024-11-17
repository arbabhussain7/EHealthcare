import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/Resigtration/Login.dart';
import 'package:healthcare/views/profile/account_detail.dart';
import 'package:healthcare/views/profile/privacy_policy.dart';
import 'package:healthcare/views/profile/setting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> signOut() async {
  try {
    // Create instances of GoogleSignIn and FirebaseAuth
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    // Sign out from Firebase Auth
    await firebaseAuth.signOut();

    // Sign out from Google Sign-In
    await googleSignIn.signOut();

    print("User signed out successfully.");
  } catch (e) {
    print("Error during sign out: $e");
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 12.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Profile",
                    style: GoogleFonts.urbanist(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor),
                  ),
                  Container(
                    width: 42.w,
                    padding: const EdgeInsets.all(8),
                    height: 42.h,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: silverColor),
                    child: const SvgIcon(
                        icon:
                            SvgIconData("assets/icons/notification-icon.svg")),
                  )
                ],
              ),
              SizedBox(
                height: 33.h,
              ),
              Container(
                width: 335.w,
                height: 92.h,
                padding: EdgeInsets.only(top: 12.h),
                decoration: BoxDecoration(
                    color: cyanColor,
                    borderRadius: BorderRadius.circular(12.r)),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/patient.png"),
                  ),
                  title: Text(
                    "$userName",
                    style: GoogleFonts.urbanist(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: whiteColor),
                  ),
                  subtitle: Text(
                    emailController.text,
                    style: GoogleFonts.urbanist(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: silverColor),
                  ),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Text(
                "General",
                style: GoogleFonts.urbanist(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: greyColor),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => const AccountDetail());
                },
                child: ListTile(
                  leading: Image.asset("assets/images/user-icon.png"),
                  title: Text(
                    "Account Information",
                    style: GoogleFonts.urbanist(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor),
                  ),
                  subtitle: Text(
                    "Change your account information",
                    style: GoogleFonts.urbanist(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: greyColor),
                  ),
                  trailing: const SvgIcon(
                      size: 20,
                      icon: SvgIconData(
                        "assets/icons/forward-icon.svg",
                      )),
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () {
                  Get.to(() => const SettingScreen());
                },
                child: ListTile(
                  leading: Image.asset("assets/images/setting-icon.png"),
                  title: Text(
                    "Settings",
                    style: GoogleFonts.urbanist(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor),
                  ),
                  subtitle: Text(
                    "Manage & Settings",
                    style: GoogleFonts.urbanist(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: greyColor),
                  ),
                  trailing: const SvgIcon(
                      size: 20,
                      icon: SvgIconData(
                        "assets/icons/forward-icon.svg",
                      )),
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () {
                  Get.to(() => const PrivacyPolicy());
                },
                child: ListTile(
                  leading: Image.asset("assets/images/medicine-icon.png"),
                  title: Text(
                    "Privacy & Policy",
                    style: GoogleFonts.urbanist(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor),
                  ),
                  subtitle: Text(
                    "Read privacy & policy",
                    style: GoogleFonts.urbanist(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: greyColor),
                  ),
                  trailing: const SvgIcon(
                      size: 20,
                      icon: SvgIconData(
                        "assets/icons/forward-icon.svg",
                      )),
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () async {
                  await signOut();
                  Get.to(() => const Signin());
                },
                child: ListTile(
                  leading: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: softGreyColor),
                    child: const Icon(
                      Icons.logout,
                      color: redColor,
                    ),
                  ),
                  title: Text(
                    "Logout Account",
                    style: GoogleFonts.urbanist(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor),
                  ),
                  subtitle: Text(
                    "Log out your account",
                    style: GoogleFonts.urbanist(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: greyColor),
                  ),
                  trailing: const SvgIcon(
                      size: 20,
                      icon: SvgIconData(
                        "assets/icons/forward-icon.svg",
                      )),
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    ));
  }
}
