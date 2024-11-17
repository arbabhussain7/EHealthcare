import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/Book1/Book3.dart';
import 'package:healthcare/views/widgets/custom_button.dart';

class BookingStepTwo extends StatefulWidget {
  const BookingStepTwo({super.key});

  @override
  State<BookingStepTwo> createState() => _BookingStepTwoState();
}

class _BookingStepTwoState extends State<BookingStepTwo> {
  DateTime? selectedDay; // Nullable DateTime for selected date
  String? selectedTime; // Nullable string to store the selected time

  // List of available times
  final List<String> morningTimes = [
    "08:00 AM",
    "08:30 AM",
    "09:00 AM",
    "09:30 AM",
    "10:00 AM",
    "10:30 AM"
  ];
  final List<String> nightTimes = [
    "08:00 PM",
    "08:30 PM",
    "09:00 PM",
    "09:30 PM",
    "10:00 PM",
    "10:30 PM"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    // Add navigation logic here if necessary
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: blackColor,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  "Booking Appointment",
                  style: GoogleFonts.urbanist(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: blackColor,
                  ),
                ),
                SizedBox(height: 72.h),
                Text(
                  "Select Schedule",
                  style: GoogleFonts.urbanist(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                // Corrected Timeline Widget with the right callback signature
                EasyDateTimeLine(
                  initialDate: DateTime.now(),
                  activeColor: cyanColor,
                  onDateChange: (date) {
                    setState(() {
                      selectedDay = date; // Update selected date
                    });
                  },
                  headerProps: const EasyHeaderProps(
                    showHeader: true,
                    centerHeader: false,
                    showSelectedDate: false,
                    showMonthPicker: false,
                  ),
                  dayProps: const EasyDayProps(
                    width: 56.0,
                    height: 93.0,
                    activeDayStyle: DayStyle(
                      borderRadius: 32.0,
                    ),
                    inactiveDayStyle: DayStyle(
                      borderRadius: 32.0,
                    ),
                  ),
                  timeLineProps: const EasyTimeLineProps(
                    hPadding: 16.0, // padding from left and right
                    separatorPadding: 10.0, // padding between days
                  ),
                ),
                SizedBox(height: 12.h),
                const Divider(endIndent: 8, color: silverColor),
                SizedBox(height: 12.h),
                Text(
                  "Morning",
                  style: GoogleFonts.urbanist(
                    fontSize: 12.sp,
                    color: greyColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 18.h),
                Wrap(
                  runSpacing: 12,
                  spacing: 12,
                  children: morningTimes.map((time) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTime = time; // Update selected time
                        });
                      },
                      child: Container(
                        width: 101.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: silverColor),
                          borderRadius: BorderRadiusDirectional.circular(22.r),
                          color: selectedTime == time
                              ? cyanColor
                              : Colors.transparent,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            time,
                            style: GoogleFonts.urbanist(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: selectedTime == time
                                  ? Colors.white
                                  : textColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12.h),
                const Divider(endIndent: 8, color: silverColor),
                SizedBox(height: 12.h),
                Text(
                  "Night",
                  style: GoogleFonts.urbanist(
                    fontSize: 12.sp,
                    color: greyColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 18.h),
                Wrap(
                  runSpacing: 12,
                  spacing: 12,
                  children: nightTimes.map((time) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTime = time; // Update selected time
                        });
                      },
                      child: Container(
                        width: 101.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: silverColor),
                          borderRadius: BorderRadiusDirectional.circular(22.r),
                          color: selectedTime == time
                              ? cyanColor
                              : Colors.transparent,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            time,
                            style: GoogleFonts.urbanist(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: selectedTime == time
                                  ? Colors.white
                                  : textColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 120.h),
                // Continue button logic
                CustomButton(
                  text: "Continue",
                  onPressed: (selectedDay != null && selectedTime != null)
                      ? () {
                          // Pass selected date and time to the next screen
                          Get.to(() => BookingStepThree(
                                selectedDate: selectedDay!,
                                selectedTime: selectedTime!,
                              ));
                        }
                      : () {}, // Provide a no-op function if both are not selected
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
