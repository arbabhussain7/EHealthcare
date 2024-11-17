import 'dart:convert';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/connect.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/Resigtration/Login.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingConfirmation extends StatefulWidget {
  final int id;
  final String meetingurl;
  const BookingConfirmation(
      {super.key, required this.id, required this.meetingurl});

  @override
  State<BookingConfirmation> createState() => _BookingConfirmationState();
}

class _BookingConfirmationState extends State<BookingConfirmation> {
  List<dynamic> doctors = [];
  List<dynamic> appointments = [];
  bool isLoading = true;
  bool hasAppointments = false;
  int patientId = id;

  Future<void> launchMeetingUrl(String meetingUrl) async {
    try {
      // First validate if the URL is not empty and properly formatted
      if (meetingUrl.isEmpty) {
        throw 'Meeting URL cannot be empty';
      }

      // Create URI object and validate
      final Uri uri = Uri.parse(meetingUrl);
      if (!uri.hasScheme || !uri.hasAuthority) {
        throw 'Invalid URL format';
      }

      // Check if URL can be launched and launch it
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $meetingUrl';
      }
    } catch (e) {
      // Handle any errors that occurred
      throw 'Failed to launch meeting: $e';
    }
  }

  Future<void> fetchAppointments(int patientId) async {
    final String apiUrl = '${Api.appointment}?patient_id=$patientId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          List<dynamic> fetchedAppointments = responseData['data'];

          if (fetchedAppointments.isNotEmpty) {
            setState(() {
              hasAppointments = true;
              appointments = fetchedAppointments;
            });

            for (var appointment in fetchedAppointments) {
              var doctorId = appointment['doctor_id'];

              if (doctorId != null && doctorId is int) {
                fetchDoctors(doctorId);
              } else if (doctorId != null && doctorId is String) {
                int? parsedDoctorId = int.tryParse(doctorId);
                if (parsedDoctorId != null) {
                  fetchDoctors(parsedDoctorId);
                } else {
                  print('Failed to parse Doctor ID.');
                }
              } else {
                print('Doctor ID is null or invalid for this appointment.');
              }
            }
          } else {
            setState(() {
              hasAppointments = false;
              isLoading = false;
            });
          }
        } else {
          setState(() {
            isLoading = false;
          });
          print('Error: ${responseData['message']}');
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
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
        setState(() {
          doctors = fetchedDoctors;
          isLoading = false;
        });
      } else if (responseBody['data'] is Map<String, dynamic>) {
        setState(() {
          doctors = [responseBody['data']]; // Wrap single doctor in a list
          isLoading = false;
        });
      } else {
        print('Unexpected data format');
      }
    } else {
      print('Failed to fetch doctor data.');
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(String rawDate) {
    try {
      DateTime parsedDate = DateTime.parse(rawDate);
      // Format the date as "Thursday, 11 Jun 2022"
      return DateFormat('EEEE, dd MMM yyyy').format(parsedDate);
    } catch (e) {
      print('Error parsing date: $e');
      return 'Invalid Date';
    }
  }

// Function to format the time
  String formatTime(String rawTime) {
    try {
      // Assuming rawTime is in HH:MM:SS format
      DateTime parsedTime =
          DateTime.parse("1970-01-01 $rawTime"); // Dummy date for time
      // Format the time as "08:00 AM"
      return DateFormat('hh:mm a').format(parsedTime);
    } catch (e) {
      print('Error parsing time: $e');
      return 'Invalid Time';
    }
  }

  @override
  void initState() {
    super.initState();

    fetchAppointments(patientId);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        fetchAppointments(patientId);
      },
      child: Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(Icons.arrow_back_ios)),
                        Text(
                          "Booking Detail",
                          style: GoogleFonts.urbanist(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: textColor),
                        ),
                        const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.transparent,
                        )
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Booking Info",
                      style: GoogleFonts.urbanist(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: textColor),
                    ),
                    Container(
                      width: 77.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                          color: greenColor,
                          borderRadius: BorderRadius.circular(4.r)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Confirmed",
                          style: GoogleFonts.urbanist(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: whiteColor),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 22.h,
                ),
                Container(
                  width: 334.w,
                  height: 48.h,
                  padding: EdgeInsets.only(left: 12.w),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(3, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset("assets/images/alert-icon.png"),
                      SizedBox(
                        width: 12.w,
                      ),
                      RichText(
                          text: TextSpan(
                              text: "Tap ",
                              style: GoogleFonts.urbanist(
                                  fontSize: 12.sp,
                                  color: textColor,
                                  fontWeight: FontWeight.w400),
                              children: [
                            TextSpan(
                                text: "Enter Waiting Room",
                                style: GoogleFonts.urbanist(
                                    color: textColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp)),
                            TextSpan(
                              text: " no earlier to 15 min",
                              style: GoogleFonts.urbanist(
                                  fontSize: 12.sp,
                                  color: textColor,
                                  fontWeight: FontWeight.w400),
                            )
                          ])),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  width: 335.w,
                  height: 230.h,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: silverColor,
                      borderRadius: BorderRadius.circular(5.r)),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          width: 42.w,
                          height: 42.h,
                          padding: const EdgeInsets.all(6.0),
                          decoration: const BoxDecoration(
                              color: whiteColor, shape: BoxShape.circle),
                          child: const SvgIcon(
                              icon: SvgIconData(
                                  ("assets/icons/calender-icon.svg"))),
                        ),
                        title: Text(
                          "Date & Time",
                          style: GoogleFonts.urbanist(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: textColor),
                        ),
                        subtitle: appointments.isNotEmpty
                            ? Text(
                                "${(appointments[0]['day'])}\n${formatTime(appointments[0]['start_time'])}",
                                style: GoogleFonts.urbanist(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: greyColor),
                              )
                            : const Text("No appointment data available"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: const Divider(),
                      ),
                      ListTile(
                        leading: Container(
                            width: 42.w,
                            height: 42.h,
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                                color: greenColor, // border: Border.all(),
                                shape: BoxShape.circle),
                            child: const SvgIcon(
                                color: whiteColor,
                                icon: SvgIconData(
                                  "assets/icons/video-type-icon.svg",
                                ))),
                        title: Text(
                          "Appointment Type",
                          style: GoogleFonts.urbanist(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: textColor),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Appointment Type",
                              style: GoogleFonts.urbanist(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: greyColor),
                            ),
                            ElevatedButton(
                              onPressed: appointments.isEmpty
                                  ? null
                                  : () async {
                                      try {
                                        await launchMeetingUrl(
                                            appointments.last['meeting_link']);
                                      } catch (e) {
                                        // Show error to user
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(e.toString()),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2)),
                                  backgroundColor: cyanColor,
                                  minimumSize: Size(130.w, 30.h)),
                              child: Text(
                                "Enter Waiting Room",
                                style: GoogleFonts.urbanist(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: whiteColor),
                              ),
                            )
                          ],
                        ),
                        // isThreeLine: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 22.h,
                ),
                Text(
                  "Doctor Info",
                  style: GoogleFonts.urbanist(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor),
                ),
                isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator()) // Show loading spinner
                    : doctors.isNotEmpty
                        ? ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                "https://cancerdetection.tech/web/" +
                                        doctors[0]['avatar'] ??
                                    "assets/images/doctor-placeholder.png",
                              ),
                            ),
                            title: Text(
                              doctors[0]['full_name'] ?? "Doctor Name",
                              style: GoogleFonts.urbanist(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                            subtitle: Text(
                              doctors[0]['specialty'] ?? "Specialization",
                              style: GoogleFonts.urbanist(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: greyColor,
                              ),
                            ),
                          )
                        : Text(
                            "No doctor information available.",
                            style: GoogleFonts.urbanist(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: greyColor,
                            ),
                          ),
                SizedBox(
                  height: 133.h,
                ),
                Text(
                  "Payment Info",
                  style: GoogleFonts.urbanist(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Price",
                      style: GoogleFonts.urbanist(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: textColor),
                    ),
                    Text(
                      appointments.isNotEmpty
                          ? "${appointments[0]['fees'] ?? '0'}"
                          : "\$0",
                      style: GoogleFonts.urbanist(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: textColor),
                    )
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tax",
                      style: GoogleFonts.urbanist(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: textColor),
                    ),
                    Text(
                      "0",
                      style: GoogleFonts.urbanist(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: textColor),
                    )
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Payment Total",
                      style: GoogleFonts.urbanist(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: textColor),
                    ),
                    Text(
                      appointments.isNotEmpty
                          ? "${appointments[0]['fees'] ?? '0'}"
                          : "\$0",
                      style: GoogleFonts.urbanist(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
