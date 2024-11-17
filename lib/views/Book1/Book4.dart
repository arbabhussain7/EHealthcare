import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/Book1/Book5.dart';
import 'package:healthcare/views/widgets/custom_button.dart';

class BookingStepFour extends StatefulWidget {
  final String selectedDisease;
  final DateTime selectedDate;
  final String selectedTime;

  const BookingStepFour({
    Key? key,
    required this.selectedDisease,
    required this.selectedDate,
    required this.selectedTime,
  }) : super(key: key);

  @override
  State<BookingStepFour> createState() => _BookingStepFourState();
}

class _BookingStepFourState extends State<BookingStepFour> {
  final List<String> listOfImage = [
    "assets/images/hblCard-img.png",
    "assets/images/jazzCash-img.png",
    "assets/images/hblCard-img.png",
    "assets/images/jazzCash-img.png",
    "assets/images/hblCard-img.png",
    "assets/images/jazzCash-img.png",
  ];
  bool? isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 12.h,
              ),
              Container(
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 32,
                    )),
              ),
              SizedBox(
                height: 22.h,
              ),
              Text(
                "Booking Appointment",
                style: GoogleFonts.urbanist(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor),
              ),
              SizedBox(
                height: 77.h,
              ),
              Text(
                "Payment Method",
                style: GoogleFonts.urbanist(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor),
              ),
              SizedBox(
                height: 22.h,
              ),
              Align(
                child: Text(
                  "Choose any Payment Method ",
                  style: GoogleFonts.urbanist(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor),
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
              SizedBox(
                height: 225.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.asset(
                      listOfImage[index],
                      width: 257.w,
                      height: 165.h,
                    );
                  },
                  itemCount: listOfImage.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      width: 12.w,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 165.h,
              ),
              Row(
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: whiteColor,
        child: CustomButton(
            text: "Continue",
            onPressed: () {
              // Example of calling BookingStepFive from another screen
              Get.to(() => BookingStepFive(
                    selectedDate: widget.selectedDate, // Pass the selected date
                    selectedTime: widget.selectedTime, // Pass the selected time
                    selectedDisease:
                        widget.selectedDisease, // Pass the selected disease
                  ));
            }),
      ),
    );
  }
}
