import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/connect.dart';
import 'package:healthcare/views/Resigtration/Login.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:healthcare/constant/colors_const.dart';

class TextMessage extends StatefulWidget {
  final int doctorId;
  final int pid;
  final String doctorName;
  final String specialty;

  const TextMessage(
      {super.key,
      required this.doctorName,
      required this.pid,
      required this.specialty,
      required this.doctorId});

  @override
  State<TextMessage> createState() => _TextMessageState();
}

class _TextMessageState extends State<TextMessage> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? currentUserID;
  String? doctorId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointments(); // Fetch appointments to get doctorId
    getCurrentUserID(); // Get the current user's ID
  }

  Future<void> getCurrentUserID() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      currentUserID = user?.uid;
    });
  }

  Future<void> fetchAppointments() async {
    final String apiUrl =
        '${Api.fetchappointment}?patient_id=$id'; // Replace $id with actual patient ID

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          List<dynamic> appointments = responseData['data'];

          if (appointments.isNotEmpty) {
            setState(() {
              doctorId =
                  appointments[0]['doctor_id'].toString(); // Get doctorId
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void sendMessage(String message, [String? imageUrl]) {
    if (message.isNotEmpty || imageUrl != null) {
      var messageData = {
        'text': message,
        'senderId': id, // Ensure senderId is int
        'doctorId': widget.doctorId, // Include doctorId
        'timestamp': FieldValue.serverTimestamp(),
        'imageUrl': imageUrl ?? '',
      };
      _firestore.collection('messages').add(messageData);
      _messageController.clear();
    }
  }

  Stream<QuerySnapshot> fetchMessages() {
    return _firestore
        .collection('messages')
        .where('senderId', isEqualTo: id) // Current user ID
        .where('doctorId',
            isEqualTo: widget.doctorId) // Add the doctor ID to filter messages
        .orderBy('timestamp', descending: false) // Order by timestamp
        .snapshots();
  }

  Future<void> pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File file = File(image.path);
      try {
        String fileName =
            'chat/${DateTime.now().millisecondsSinceEpoch}_${image.name}';
        TaskSnapshot snapshot = await _storage.ref(fileName).putFile(file);
        String imageUrl = await snapshot.ref.getDownloadURL();
        sendMessage('', imageUrl); // Send message with image URL
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios, color: blackColor),
        ),
        title: isLoading
            ? const CircularProgressIndicator()
            : ListTile(
                leading: const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/doctor-warda.png"),
                ),
                title: Text(
                  widget.doctorName,
                  style: GoogleFonts.urbanist(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor),
                ),
                subtitle: Text(
                  widget.specialty,
                  style: GoogleFonts.urbanist(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: greyColor),
                ),
              ),
      ),
      backgroundColor: silverColor,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: fetchMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No messages yet.",
                      style: GoogleFonts.urbanist(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                          color: greyColor),
                    ),
                  );
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var messageData =
                        messages[index].data() as Map<String, dynamic>;
                    bool isMe = messageData['senderId'] ==
                        id; // Assuming senderId is the current user id

                    return Container(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (messageData['imageUrl'] != null &&
                              messageData['imageUrl'] != '')
                            Image.network(
                              messageData['imageUrl'],
                              width: 150,
                              height: 150,
                            ),
                          if (messageData['text'] != null &&
                              messageData['text'] != '')
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    isMe ? Colors.blueAccent : Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                messageData['text'],
                                style: GoogleFonts.urbanist(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: isMe ? Colors.white : Colors.black),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 5.w),
            child: TextFormField(
              controller: _messageController,
              style: GoogleFonts.urbanist(
                  fontSize: 22.w,
                  fontWeight: FontWeight.w500,
                  color: textColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: whiteColor,
                prefixIcon: IconButton(
                  icon: const SvgIcon(
                      icon: SvgIconData("assets/icons/paperclip-icon.svg")),
                  onPressed: pickAndUploadImage,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: cyanColor),
                  onPressed: () => sendMessage(_messageController.text.trim()),
                ),
                hintText: "Type message...",
                hintStyle: GoogleFonts.urbanist(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: greyColor),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: greyColor)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
