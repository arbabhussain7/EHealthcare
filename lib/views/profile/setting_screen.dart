import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/profile/privacy_policy.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isSwitches = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 22.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.arrow_back_ios)),
                      Text(
                        "Settings",
                        style: GoogleFonts.montserrat(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: textColor),
                      ),
                      const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.transparent,
                      ),
                    ],
                  )),
              SizedBox(
                height: 12.h,
              ),
              Text(
                "General",
                style: GoogleFonts.urbanist(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: greyColor),
              ),
              ListTile(
                  title: Text(
                    "Notifications",
                    style: GoogleFonts.urbanist(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor),
                  ),
                  trailing: Switch(
                      // autofocus: true,
                      value: isSwitches,
                      activeTrackColor: cyanColor,
                      activeColor: whiteColor,
                      onChanged: (value) {
                        setState(() {
                          isSwitches = value;
                        });
                      })),
              const Divider(
                color: silverColor,
              ),
              ListTile(
                title: Text(
                  "Contact Us",
                  style: GoogleFonts.urbanist(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor),
                ),
                trailing: const SvgIcon(
                    size: 10,
                    icon: SvgIconData("assets/icons/forward-icon.svg")),
              ),
              const Divider(
                color: silverColor,
              ),
              SizedBox(
                height: 22.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 12.h),
                child: Text(
                  "About",
                  style: GoogleFonts.urbanist(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: greyColor),
                ),
              ),
              const Divider(
                color: silverColor,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => const PrivacyPolicy());
                },
                child: ListTile(
                  title: Text(
                    "Privacy Policy",
                    style: GoogleFonts.urbanist(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor),
                  ),
                  trailing: const SvgIcon(
                      size: 10,
                      icon: SvgIconData(
                        "assets/icons/forward-icon.svg",
                      )),
                ),
              ),
              const Divider(
                color: silverColor,
              ),
              ListTile(
                title: Text(
                  "About Us",
                  style: GoogleFonts.urbanist(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor),
                ),
                trailing: const SvgIcon(
                    size: 10,
                    icon: SvgIconData("assets/icons/forward-icon.svg")),
              ),
              const Divider(
                color: silverColor,
              ),
              ListTile(
                title: Text(
                  "FAQ",
                  style: GoogleFonts.urbanist(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor),
                ),
                trailing: const SvgIcon(
                    size: 10,
                    icon: SvgIconData(
                      "assets/icons/forward-icon.svg",
                    )),
              ),
              const Divider(
                color: silverColor,
              ),
              ListTile(
                title: Text(
                  "Legal",
                  style: GoogleFonts.urbanist(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor),
                ),
                trailing: const SvgIcon(
                    icon: SvgIconData("assets/icons/forward-icon.svg")),
              ),
              const Divider(
                color: silverColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
