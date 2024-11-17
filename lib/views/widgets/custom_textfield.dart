import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/constant/colors_const.dart';

// ignore: must_be_immutable
class CustomTextfield extends StatefulWidget {
  CustomTextfield({
    super.key,
    required this.text,
    this.obscureText = false,
    this.isPassword = false,
    required this.controller,
    this.secureText = false,
    this.validator,
    this.inputType = TextInputType.text,
    this.suffixIcons,
    required this.prefixIcons,
  });
  final String text;

  final TextEditingController controller;

  bool isPassword;
  final Icon prefixIcons;
  bool secureText;
  final String? Function(String?)? validator;
  final TextInputType inputType;
  bool obscureText;
  IconData? suffixIcons;
  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 6.h),
      child: Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: greyColor))),
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          style: GoogleFonts.urbanist(
              color: blackAccColor,
              fontSize: 17.sp,
              fontWeight: FontWeight.w700),
          keyboardType: TextInputType.text,
          validator: widget.validator,
          decoration: InputDecoration(
            focusColor: cyanColor,
            border: InputBorder.none,
            hintText: widget.text,
            hintStyle: GoogleFonts.urbanist(
                fontSize: 14.sp, fontWeight: FontWeight.w400, color: greyColor),
            icon: widget.prefixIcons,
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.secureText = !widget.secureText;
                        widget.obscureText = !widget.obscureText;
                      });
                      print(widget.secureText);
                    },
                    child: widget.secureText
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
