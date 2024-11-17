import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/constant/colors_const.dart';

class PredictedDiease extends StatefulWidget {
  final Map<String, dynamic> predictionData;

  const PredictedDiease({
    super.key,
    required this.predictionData,
  });

  @override
  State<PredictedDiease> createState() => _PredictedDieaseState();
}

class _PredictedDieaseState extends State<PredictedDiease> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prediction Results',
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Predicted Disease',
              widget.predictionData['predicted_disease'],
              isTitle: true,
            ),
            SizedBox(height: 16.h),
            _buildSection(
              'Description',
              widget.predictionData['description'],
            ),
            SizedBox(height: 16.h),
            _buildListSection(
              'Precautions',
              List<String>.from(widget.predictionData['precautions']),
            ),
            SizedBox(height: 16.h),
            _buildListSection(
              'Medications',
              List<String>.from(widget.predictionData['medications']),
            ),
            SizedBox(height: 16.h),
            _buildListSection(
              'Diet',
              List<String>.from(widget.predictionData['diet']),
            ),
            SizedBox(height: 16.h),
            _buildListSection(
              'Workout & Lifestyle',
              List<String>.from(widget.predictionData['workout']),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, {bool isTitle = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          content,
          style: GoogleFonts.urbanist(
            fontSize: isTitle ? 24.sp : 16.sp,
            fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
            color: isTitle ? Colors.grey : textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildListSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        SizedBox(height: 8.h),
        ...items
            .map((item) => Padding(
                  padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 8.h),
                        width: 6.w,
                        height: 6.w,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          item.replaceAll(RegExp(r"[\[\]']"), ''),
                          style: GoogleFonts.urbanist(
                            fontSize: 16.sp,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }
}
