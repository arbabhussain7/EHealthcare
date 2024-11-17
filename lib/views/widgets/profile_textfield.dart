import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/constant/colors_const.dart';

class ProfileTextField extends StatelessWidget {
  const ProfileTextField({
    super.key,
    required this.text,
    required this.inputtext,
    required this.controller,
    this.readOnly = false,
  });
  final bool readOnly;
  final String text;
  final TextInputType inputtext;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: TextFormField(
        readOnly: readOnly,
        controller: controller,
        style: GoogleFonts.urbanist(
            fontSize: 14.sp, fontWeight: FontWeight.w700, color: textColor),
        keyboardType: inputtext,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: GoogleFonts.urbanist(
              fontSize: 15.sp, fontWeight: FontWeight.w400, color: greyColor),
        ),
      ),
    );
  }
}
