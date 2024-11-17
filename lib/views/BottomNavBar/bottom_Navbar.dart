import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/Appointment/appointment.dart';
import 'package:healthcare/views/Home/home.dart';
import 'package:healthcare/views/messsages/messages.dart';
import 'package:healthcare/views/profile/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  var index = 0;
  List<Widget> WidgetList = const [
    homeScreen(),
    Appointments(),
    MessageScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: WidgetList[index],
      bottomNavigationBar: Container(
        // color: whiteColor,
        padding: const EdgeInsets.all(18.0),
        child: Container(
          height: 54.h,
          width: 323.w,
          decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(44.r),
              boxShadow: [
                BoxShadow(
                    color: greyColor.withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 10)
              ]),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 42.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      index = 0;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/home-icon.png",
                        width: 18.w,
                        height: 17.h,
                        color: index == 0 ? cyanColor : null,
                      ),
                      index == 0
                          ? Container(
                              margin: EdgeInsets.only(top: 2.h),
                              height: 2.h,
                              width: 18.w,
                              decoration: BoxDecoration(
                                  color: cyanColor,
                                  borderRadius: BorderRadius.circular(7.r)),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                        index = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/Appointment-icon.png",
                          width: 18.w,
                          height: 17.h,
                          color: index == 1 ? cyanColor : null,
                        ),
                        index == 1
                            ? Container(
                                margin: EdgeInsets.only(top: 2.h),
                                height: 2.h,
                                width: 18.w,
                                decoration: BoxDecoration(
                                    color: cyanColor,
                                    borderRadius: BorderRadius.circular(7.r)),
                              )
                            : const SizedBox()
                      ],
                    )),
                InkWell(
                    onTap: () {
                      setState(() {
                        index = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/Message-icon.png",
                          width: 18.w,
                          height: 17.h,
                          color: index == 2 ? cyanColor : null,
                        ),
                        index == 2
                            ? Container(
                                margin: EdgeInsets.only(top: 2.h),
                                height: 2.h,
                                width: 18.w,
                                decoration: BoxDecoration(
                                    color: cyanColor,
                                    borderRadius: BorderRadius.circular(7.r)),
                              )
                            : const SizedBox()
                      ],
                    )),
                InkWell(
                    onTap: () {
                      setState(() {
                        index = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/profile-icon.png",
                          width: 18.w,
                          height: 17.h,
                        ),
                        index == 3
                            ? Container(
                                margin: EdgeInsets.only(top: 2.h),
                                height: 2.h,
                                width: 18.w,
                                decoration: BoxDecoration(
                                    color: cyanColor,
                                    borderRadius: BorderRadius.circular(7.r)),
                              )
                            : const SizedBox()
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
