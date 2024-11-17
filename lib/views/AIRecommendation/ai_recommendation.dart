import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/connect.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/AIRecommendation/Predicted_diease.dart';
import 'package:healthcare/views/widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AiRecommendation extends StatefulWidget {
  const AiRecommendation({super.key});

  @override
  State<AiRecommendation> createState() => _AiRecommendationState();
}

class _AiRecommendationState extends State<AiRecommendation> {
  bool isSelectedClick = false;
  final selectedController = TextEditingController();
  List<String> storeDiease = [];
  var skills = [].obs;
  var filteredSkills = [].obs;
  final searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSymptoms();
  }

  void filterSymptoms(String query) {
    if (query.isEmpty) {
      filteredSkills.value = List.from(skills);
    } else {
      filteredSkills.value = skills
          .where((skill) => skill['name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
  }

  Future<void> fetchSymptoms() async {
    final url = Uri.parse('${Api.con}/fetch_symptoms.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            skills.value = data['data']
                .map((item) => {
                      "name": item['symptom'].replaceAll('_', ' '),
                      'isCheck': false
                    })
                .toList();
            filteredSkills.value = List.from(skills);
          });
        }
      } else {
        print('Failed to load symptoms');
      }
    } catch (e) {
      print('Error fetching symptoms: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 22.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/patient.png"),
                  ),
                  Container(
                    width: 42.w,
                    padding: const EdgeInsets.all(8),
                    height: 42.h,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border(),
                        color: silverColor),
                    child: const SvgIcon(
                        icon:
                            SvgIconData("assets/icons/notification-icon.svg")),
                  )
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "Enter your symptoms",
              style: GoogleFonts.urbanist(
                  fontSize: 22.h,
                  color: blackColor,
                  fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
              child: TextField(
                style: GoogleFonts.urbanist(
                  color: Colors.black,
                  fontSize: 16.sp,
                ),
                controller: searchController,
                onChanged: filterSymptoms,
                decoration: InputDecoration(
                  hintText: 'Search symptoms...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ),
            if (storeDiease.isNotEmpty)
              Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.r),
                        color: silverColor,
                      ),
                      child: Center(
                        child: Text(
                          storeDiease[index],
                          style: GoogleFonts.urbanist(
                            fontSize: 15.r,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(width: 8.w),
                  itemCount: storeDiease.length,
                ),
              ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  itemCount: filteredSkills.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        filteredSkills[index]['name'],
                        style: GoogleFonts.urbanist(fontSize: 18),
                      ),
                      trailing: Checkbox(
                        value: filteredSkills[index]['isCheck'],
                        onChanged: (value) {
                          setState(() {
                            // Update both filtered and original lists
                            int originalIndex = skills.indexWhere((skill) =>
                                skill['name'] == filteredSkills[index]['name']);
                            if (originalIndex != -1) {
                              skills[originalIndex]['isCheck'] = value;
                              filteredSkills[index]['isCheck'] = value;
                              if (value!) {
                                storeDiease.add(filteredSkills[index]['name']);
                              } else {
                                storeDiease
                                    .remove(filteredSkills[index]['name']);
                              }
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            // Replace the last SizedBox widget in AiRecommendation with this:
            isLoading
                ? const CircularProgressIndicator(
                    strokeWidth: 2,
                  )
                : CustomButton(
                    onPressed: () async {
                      if (storeDiease.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Please select at least one symptom',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      setState(() {
                        isLoading = true;
                      });

                      try {
                        final response = await http.post(
                          Uri.parse(
                              'https://cancerdetection.tech/care/predict-disease/'),
                          headers: {'Content-Type': 'application/json'},
                          body: json.encode({
                            'symptoms': storeDiease
                                .map((symptom) =>
                                    symptom.replaceAll(' ', '_').toLowerCase())
                                .toList(),
                          }),
                        );

                        if (response.statusCode == 200) {
                          final data = json.decode(response.body);
                          setState(() {
                            isLoading = false;
                          });
                          Get.to(() => PredictedDiease(predictionData: data));
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          Get.snackbar(
                            'Slow Internet',
                            'Unstable Internet! Please Try Again.',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        Get.snackbar(
                          'Slow Internet',
                          'Unstable Internet! Please Try Again.',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    text: 'Predict Disease',
                  ).paddingAll(16)
          ],
        ),
      ),
    );
  }
}
