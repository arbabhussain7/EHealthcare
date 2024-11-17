import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/connect.dart';
import 'package:healthcare/views/Resigtration/Login.dart';
import 'package:healthcare/views/messsages/sendmessage.dart';
import 'package:http/http.dart' as http;
import 'package:healthcare/constant/colors_const.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<dynamic> doctors = [];
  bool isLoading = true;
  bool hasAppointments = false;
  int patientId = id;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    fetchAppointments(patientId);
    fetchLastMessages(id);
  }

  Future<void> fetchAppointments(int patientId) async {
    final String apiUrl = '${Api.appointment}?patient_id=$patientId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      log(response.body.toString());

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          List<dynamic> appointments = responseData['data'];

          if (appointments.isNotEmpty) {
            setState(() {
              hasAppointments = true;
            });

            for (var appointment in appointments) {
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

  Stream<QuerySnapshot> fetchLastMessages(int senderId) {
    return _firestore
        .collection('messages')
        .where('senderId', isEqualTo: id) // Filter messages by senderId
        .orderBy('timestamp', descending: true) // Get the latest message
        .limit(1) // Limit to the last message
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : hasAppointments
                ? SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 22.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Message",
                                  style: GoogleFonts.urbanist(
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.w700,
                                      color: blackColor),
                                ),
                                SizedBox(width: 94.w),
                                Container(
                                  width: 42.w,
                                  height: 42.h,
                                  decoration: const BoxDecoration(
                                      color: silverColor,
                                      shape: BoxShape.circle),
                                  child:
                                      const Icon(Icons.add, color: blackColor),
                                ),
                                Container(
                                  width: 42.w,
                                  height: 42.h,
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                      color: silverColor,
                                      shape: BoxShape.circle),
                                  child: const SvgIcon(
                                      icon: SvgIconData(
                                          "assets/icons/notification-icon.svg")),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 265.w,
                                  height: 48.h,
                                  child: TextFormField(
                                    style: GoogleFonts.urbanist(
                                        fontSize: 17.sp, color: textColor),
                                    decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.search,
                                          size: 34,
                                          color: textColor,
                                        ),
                                        hintText: "Search message",
                                        hintStyle: GoogleFonts.urbanist(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: greyColor)),
                                  ),
                                ),
                                Container(
                                    width: 42.w,
                                    height: 42.h,
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                        color: silverColor,
                                        shape: BoxShape.circle),
                                    child: const SvgIcon(
                                      icon: SvgIconData(
                                          "assets/icons/filter-icon.svg"),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 645.h,
                            child: ListView.separated(
                              itemBuilder: (BuildContext context, int index) {
                                final doctor = doctors[index];

                                return GestureDetector(
                                  onTap: () {
                                    // Navigate to TextMessage screen with doctor details
                                    Get.to(() => SendMessage(
                                          pid: id,
                                          doctorName: doctor['full_name'],
                                          specialty: doctor['specialty'],
                                          doctorId: doctor['id'],
                                          url:
                                              "https://cancerdetection.tech/web/" +
                                                  doctor['avatar'],
                                        ));
                                  },
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: fetchLastMessages(doctor[
                                        'id']), // Fetch last message for the doctor
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData ||
                                          snapshot.data!.docs.isEmpty) {
                                        return ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                "https://cancerdetection.tech/web/" +
                                                    doctor['avatar']),
                                          ),
                                          title: Text(
                                            doctor['full_name'],
                                            style: GoogleFonts.urbanist(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          // subtitle: Text(
                                          //   "No messages yet",
                                          //   style: GoogleFonts.urbanist(
                                          //     fontSize: 14.sp,
                                          //     fontWeight: FontWeight.w400,
                                          //     color: textColor,
                                          //   ),
                                          // ),
                                          trailing: Text(
                                            "",
                                            style: GoogleFonts.urbanist(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                              color: greyColor,
                                            ),
                                          ),
                                        );
                                      }

                                      var lastMessage =
                                          snapshot.data!.docs.first;
                                      String messageText =
                                          lastMessage['text'] ?? "No content";
                                      Timestamp timestamp =
                                          lastMessage['timestamp'] as Timestamp;

                                      DateTime date = timestamp.toDate();
                                      String formattedTime =
                                          "${date.hour}:${date.minute}"; // Format the time

                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              "https://cancerdetection.tech/web/" +
                                                  doctor['avatar']),
                                        ),
                                        title: Text(
                                          doctor['full_name'],
                                          style: GoogleFonts.urbanist(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        subtitle: Text(
                                          messageText, // Show the last message text
                                          style: GoogleFonts.urbanist(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: textColor,
                                          ),
                                        ),
                                        trailing: Text(
                                          formattedTime, // Show the last message time
                                          style: GoogleFonts.urbanist(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: greyColor,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemCount: doctors.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      "Sorry, you can only chat if you have an appointment.",
                      style: GoogleFonts.urbanist(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: blackColor),
                    ),
                  ),
      ),
    );
  }
}
