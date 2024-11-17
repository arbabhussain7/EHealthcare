import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/connect.dart';
import 'package:healthcare/views/Appointment/appointment.dart';
import 'package:healthcare/views/Resigtration/Login.dart';
import 'package:healthcare/views/profile/profile_screen.dart';
import 'package:healthcare/views/widgets/exitdialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/Book1/Book1.dart';
import 'package:healthcare/views/Booking/Book_confirm.dart';
import 'package:url_launcher/url_launcher.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => homeScreenState();
}

class homeScreenState extends State<homeScreen> {
  List<dynamic> appointments = [];
  bool isLoading = true;
  int? patientId = id; // Example patient ID, you can dynamically pass this
  List<dynamic> doctors = [];
  String? doctorId; // Declare a variable to hold the doctor ID
  final Uri dwatson = Uri.parse('https://dwatson.pk/');
  final Uri bykea = Uri.parse('https://bykea.com/');

  Future<void> _launchURL(Uri url) async {
    try {
      // Launch in app if possible, otherwise external browser
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView, // This opens in the app
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      );
    } catch (e) {
      // If in-app fails, try external browser
      try {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        debugPrint('Could not launch $url: $e');
      }
    }
  }

  Future<void> fetchAppointments() async {
    final response =
        await http.get(Uri.parse('${Api.appointment}?patient_id=$patientId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        setState(() {
          appointments = responseData['data'];
          // Sort appointments by latest first, based on created_at
          appointments.sort((a, b) => DateTime.parse(b['created_at'])
              .compareTo(DateTime.parse(a['created_at'])));

          // Check if there are appointments and store the doctor ID
          if (appointments.isNotEmpty) {
            doctorId = appointments[0]['doctor_id'].toString();
            fetchDoctors(int.parse(doctorId!)); // Store the doctor ID
          }

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          appointments = [];
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchDoctors(int doctorId) async {
    final response =
        await http.get(Uri.parse('${Api.fetchdoctor1}?id=$doctorId'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      if (responseBody['data'] is List<dynamic>) {
        final List<dynamic> fetchedDoctors = responseBody['data'];
        for (var doctor in fetchedDoctors) {
          if (!doctors.any((d) => d['id'] == doctor['id'])) {
            doctors.add(doctor);
          }
        }
      } else if (responseBody['data'] is Map<String, dynamic>) {
        if (!doctors.any((d) => d['id'] == responseBody['data']['id'])) {
          doctors.add(responseBody['data']);
        }
      } else {
        print('Unexpected data format');
      }
      setState(() {
        isLoading = false;
      });
    } else {
      print('Failed to fetch doctor data.');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAppointments(); // Fetch appointments on widget initialization
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await DialogHelper.showExitDialog(context);
        // Return false to prevent automatic pop after dialog
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 372.w,
                  height: 342.h,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomRight,
                          colors: [gridentcyanColor, gridentwhiteColor])),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 22.w, vertical: 12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const ProfileScreen());
                              },
                              child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/patient.png"),
                              ),
                            ),
                            Container(
                              width: 42.w,
                              padding: const EdgeInsets.all(8),
                              height: 42.h,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border(),
                                  color: whiteColor),
                              child: const SvgIcon(
                                  icon: SvgIconData(
                                      "assets/icons/notification-icon.svg")),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 32.h,
                      ),
                      Stack(
                        children: [
                          Container(
                            width: 335.w,
                            height: 167.h,
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "WELCOME BACK!",
                                  style: GoogleFonts.urbanist(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: textColor),
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                Text(
                                  userName, // Static for now
                                  style: GoogleFonts.urbanist(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w700,
                                      color: textColor),
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                Text(
                                  "Have a nice day 😊",
                                  style: GoogleFonts.urbanist(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: textColor),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 154, left: 92),
                            child: InkWell(
                              onTap: () {
                                Get.to(() => const Bookingstepone());
                              },
                              child: Container(
                                width: 146.w,
                                height: 48.h,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        buttongredientcyan,
                                        buttongredientscyan,
                                        buttongredientscyan
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(32.r)),
                                child: TextButton(
                                  onPressed: () {
                                    Get.to(() => const Bookingstepone());
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SvgIcon(
                                          color: whiteColor,
                                          size: 16,
                                          icon: SvgIconData(
                                            "assets/icons/button-diamond-icon.svg",
                                          )),
                                      Text(
                                        "Find Doctor",
                                        style: GoogleFonts.urbanist(
                                            color: whiteColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 375.w,
                  height: 474.h,
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(42.r),
                          topRight: Radius.circular(42.r))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 22.w, vertical: 22.h),
                        child: Text(
                          "EHealthcare Services",
                          style: GoogleFonts.urbanist(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: textColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 33.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const Bookingstepone());
                              },
                              child: Column(
                                children: [
                                  Container(
                                      width: 65.w,
                                      height: 65.h,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: silverColor),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                          "assets/images/consultant.png")),
                                  Text(
                                    "Consultation",
                                    style: GoogleFonts.urbanist(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: textColor),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _launchURL(dwatson);
                              },
                              child: Column(
                                children: [
                                  Container(
                                      width: 65.w,
                                      height: 65.h,
                                      padding: const EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: silverColor),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                          "assets/images/medicine.png")),
                                  Text(
                                    "Medicines",
                                    style: GoogleFonts.urbanist(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: textColor),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _launchURL(bykea);
                              },
                              child: Column(
                                children: [
                                  Container(
                                      width: 65.w,
                                      height: 65.h,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: silverColor),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                          "assets/images/Delivery.png")),
                                  Text(
                                    "Shipment",
                                    style: GoogleFonts.urbanist(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: textColor),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 22.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "My Appointment",
                              style: GoogleFonts.urbanist(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: textColor),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const Appointments());
                              },
                              child: Text(
                                "See All",
                                style: GoogleFonts.urbanist(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: cyanColor),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.w),
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : appointments.isNotEmpty
                                ? Container(
                                    height: 150.h,
                                    padding: const EdgeInsets.all(12),
                                    width: 335.w,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(3, 3),
                                          ),
                                        ],
                                        color: whiteColor),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "Appointment date",
                                                  style: GoogleFonts.urbanist(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: textColor),
                                                ),
                                                Text(
                                                  appointments.first['day'],
                                                  style: GoogleFonts.urbanist(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: textColor),
                                                ),
                                              ],
                                            ),
                                            const SvgIcon(
                                                icon: SvgIconData(
                                                    "assets/icons/menu-icon.svg"))
                                          ],
                                        ),
                                        const Divider(
                                          color: silverColor,
                                        ),
                                        ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                "https://cancerdetection.tech/web/${doctors[0]['avatar']}",
                                              ),
                                            ),
                                            title: Text(
                                              doctors[0]['full_name'] ??
                                                  "Doctor Name",
                                              style: GoogleFonts.urbanist(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: textColor),
                                            ),
                                            subtitle: Text(
                                              appointments.first['problem'],
                                              style: GoogleFonts.urbanist(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: greyColor),
                                            ),
                                            trailing: InkWell(
                                              onTap: () {
                                                int doctorId = int.parse(
                                                  appointments
                                                      .first['doctor_id'],
                                                );
                                                String meetingurl = appointments
                                                    .first['meeting_link'];
                                                Get.to(() =>
                                                    BookingConfirmation(
                                                      id: doctorId,
                                                      meetingurl: meetingurl,
                                                    ));
                                              },
                                              child: const SvgIcon(
                                                  size: 15,
                                                  icon: SvgIconData(
                                                    "assets/icons/forward-icon.svg",
                                                  )),
                                            )),
                                      ],
                                    ),
                                  )
                                : Text(
                                    'No Appointments Available',
                                    style: GoogleFonts.urbanist(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: textColor),
                                  ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
