import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/Book1/Book4.dart';
import 'package:healthcare/views/widgets/custom_button.dart';

class BookingStepThree extends StatefulWidget {
  final DateTime selectedDate; // Accepting selected date
  final String selectedTime; // Accepting selected time

  const BookingStepThree({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
  }) : super(key: key);

  @override
  State<BookingStepThree> createState() => _BookingStepThreeState();
}

class _BookingStepThreeState extends State<BookingStepThree> {
  // List of diseases
  final List<String> listOfDiease = [
    'Appendicitis',
    'Backache',
    'Bone fracture',
    'Cold',
    'Constipation',
    'Cough',
    'Diarrhea',
    'Dizzy',
  ];

  // Variable to track the selected disease
  int? selectedIndex;

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
                SizedBox(height: 22.h),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios, size: 32),
                ),
                SizedBox(height: 12.h),
                Text(
                  "Booking Appointment",
                  style: GoogleFonts.urbanist(
                    color: textColor,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 57),
                Text(
                  "Select Reason ",
                  style: GoogleFonts.urbanist(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: TextFormField(
                    style: GoogleFonts.urbanist(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      hintText: "Search reason",
                      focusColor: cyanColor,
                      hintStyle: GoogleFonts.urbanist(
                        fontSize: 14.sp,
                        color: greyColor,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(height: 22.h),
                SizedBox(
                  height: 544.h,
                  child: ListView.separated(
                    itemCount: listOfDiease.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index; // Update the selected index
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                listOfDiease[index],
                                style: GoogleFonts.urbanist(
                                  fontSize: 16.sp,
                                  fontWeight: selectedIndex == index
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: textColor,
                                ),
                              ),
                              // Show check mark if the current item is selected
                              selectedIndex == index
                                  ? Image.asset("assets/images/true-img.png")
                                  : const SizedBox(), // Empty widget if not selected
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(color: silverColor);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: whiteColor,
        child: CustomButton(
          text: "Continue",
          onPressed: selectedIndex != null
              ? () {
                  // Pass the selected disease, date, and time to the next screen
                  Get.to(() => BookingStepFour(
                        selectedDisease: listOfDiease[selectedIndex!],
                        selectedDate: widget.selectedDate,
                        selectedTime: widget.selectedTime,
                      ));
                }
              : () {
                  // Show a message or do nothing when no disease is selected
                  print("Please select a disease");
                },
        ),
      ),
    );
  }
}
