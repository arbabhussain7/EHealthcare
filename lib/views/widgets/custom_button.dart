import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/constant/colors_const.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 334,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            onPressed();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2), // button's shape
            ),
            backgroundColor: Colors.cyan,
            // text color
            elevation: 5, // button's elevation when it's pressed
          ),
          child: Text(text,
              style: GoogleFonts.urbanist(
                  color: whiteColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
