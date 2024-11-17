import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/BottomNavBar/bottom_Navbar.dart';
import 'package:healthcare/views/widgets/custom_button.dart';

class BookingStepSix extends StatefulWidget {
  const BookingStepSix({super.key});

  @override
  State<BookingStepSix> createState() => _BookingStepSixState();
}

class _BookingStepSixState extends State<BookingStepSix> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 146.w,
                    height: 146.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: greenAccentColor,
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      width: 106.w,
                      height: 106.h,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: greenColor),
                      child: const Icon(
                        size: 52,
                        Icons.check,
                        color: whiteColor,
                      ),
                    ),
                  ),
                  Text(
                    "Successfully",
                    style: GoogleFonts.urbanist(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Text(
                    "Your appointment has been requested",
                    style: GoogleFonts.urbanist(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: greyColor),
                  ),
                  SizedBox(
                    height: 22.h,
                  ),
                  Container(
                      width: 287.w,
                      height: 92.h,
                      decoration: BoxDecoration(
                        color: cyanColor.withOpacity(0.1),
                        border: Border.all(color: cyanColor),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: " +923 411463601",
                                    style: GoogleFonts.urbanist(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: textColor))
                              ],
                              text:
                                  "If you have any problem or any issue and you need change your visit, please call",
                              style: GoogleFonts.urbanist(
                                  color: textColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400)),
                        ),
                      )),
                  SizedBox(
                    height: 244.h,
                  )
                ],
              ),
              CustomButton(
                  text: "Back to Home",
                  onPressed: () {
                    Get.off(() => const BottomNavBar());
                  })
            ],
          ),
        ),
      ),
    );
  }
}
