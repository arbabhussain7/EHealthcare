// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg_icons/flutter_svg_icons.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:healthcare/constant/colors_const.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// class SendMessage extends StatefulWidget {
//   final int doctorId; // Receiver ID
//   final int pid; // Sender ID
//   final String doctorName;
//   final String specialty;

//   const SendMessage({
//     super.key,
//     required this.doctorName,
//     required this.pid,
//     required this.specialty,
//     required this.doctorId,
//   });

//   @override
//   State<SendMessage> createState() => _SendMessageState();
// }

// class _SendMessageState extends State<SendMessage> {
//   final TextEditingController _messageController = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   bool isLoading = true;
//   List<dynamic> messages = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchMessages(); // Fetch messages on initialization
//   }

//   Future<void> sendMessage(String message) async {
//     if (message.isNotEmpty) {
//       final String apiUrl =
//           'https://cancerdetection.tech/api/api/sendMessagePatientDoctor.php';

//       try {
//         final response = await http.post(
//           Uri.parse(apiUrl),
//           headers: {
//             'Content-Type': 'application/x-www-form-urlencoded',
//           },
//           body: {
//             'sender_id': widget.pid.toString(),
//             'receiver_id': widget.doctorId.toString(),
//             'message': message,
//           },
//         );

//         if (response.statusCode == 200) {
//           final Map<String, dynamic> responseData = json.decode(response.body);
//           if (responseData['status'] == 'success') {
//             _messageController.clear(); // Clear the text field after sending
//             fetchMessages();
//           } else {
//             // Handle error response
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                   content: Text(
//                       'Failed to send message: ${responseData['message']}')),
//             );
//           }
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error: ${response.statusCode}')),
//           );
//         }
//       } catch (e) {
//         print('Error occurred: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error occurred: $e')),
//         );
//       }
//     }
//   }

//   Future<void> fetchMessages() async {
//     final String apiUrl =
//         'https://cancerdetection.tech/api/api/getchatlist.php';
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         body: {
//           'sender_id': widget.pid.toString(), // Sender ID
//           'receiver_id': widget.doctorId.toString(), // Receiver ID
//         },
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         if (responseData['status'] == 'success') {
//           setState(() {
//             messages = responseData['data']; // Store messages
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Error occurred: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: whiteColor,
//         leading: IconButton(
//           onPressed: () => Navigator.of(context).pop(),
//           icon: const Icon(Icons.arrow_back_ios, color: blackColor),
//         ),
//         title: isLoading
//             ? const CircularProgressIndicator()
//             : ListTile(
//                 leading: const CircleAvatar(
//                   backgroundImage: AssetImage("assets/images/doctor-warda.png"),
//                 ),
//                 title: Text(
//                   widget.doctorName,
//                   style: GoogleFonts.urbanist(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w700,
//                       color: textColor),
//                 ),
//                 subtitle: Text(
//                   widget.specialty,
//                   style: GoogleFonts.urbanist(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w400,
//                       color: greyColor),
//                 ),
//               ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : messages.isEmpty
//                     ? Center(
//                         child: Text(
//                         "No messages yet.",
//                         style: TextStyle(color: Colors.black),
//                       ))
//                     : ListView.builder(
//                         itemCount: messages.length,
//                         itemBuilder: (context, index) {
//                           var messageData = messages[index];
//                           bool isMe =
//                               messageData['sender_id'] == widget.pid.toString();

//                           return Container(
//                             alignment: isMe
//                                 ? Alignment.centerRight
//                                 : Alignment.centerLeft,
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 10, horizontal: 14),
//                             child: Column(
//                               crossAxisAlignment: isMe
//                                   ? CrossAxisAlignment.end
//                                   : CrossAxisAlignment.start,
//                               children: [
//                                 if (messageData['message'] != null &&
//                                     messageData['message'] != '')
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: isMe
//                                           ? Colors.blueAccent
//                                           : Colors.grey[300],
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     padding: const EdgeInsets.all(10),
//                                     child: Text(
//                                       messageData['message'],
//                                       style: GoogleFonts.urbanist(
//                                           fontSize: 16.sp,
//                                           fontWeight: FontWeight.w500,
//                                           color: isMe
//                                               ? Colors.white
//                                               : Colors.black),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 5.w),
//             child: TextFormField(
//               controller: _messageController,
//               style: GoogleFonts.urbanist(
//                   fontSize: 22.w,
//                   fontWeight: FontWeight.w500,
//                   color: textColor),
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: whiteColor,
//                 prefixIcon: IconButton(
//                   icon: const SvgIcon(
//                       icon: SvgIconData("assets/icons/paperclip-icon.svg")),
//                   onPressed: () {
//                     sendMessage(_messageController.text.trim());
//                   },
//                 ),
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.send, color: cyanColor),
//                   onPressed: () => sendMessage(_messageController.text.trim()),
//                 ),
//                 hintText: "Type message...",
//                 hintStyle: GoogleFonts.urbanist(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w400,
//                     color: greyColor),
//                 border: const OutlineInputBorder(),
//                 focusedBorder: const OutlineInputBorder(
//                     borderSide: BorderSide(color: greyColor)),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class SendMessage extends StatefulWidget {
  final int doctorId; // Receiver ID
  final int pid; // Sender ID
  final String doctorName;
  final String specialty;
  final String url;

  const SendMessage(
      {super.key,
      required this.doctorName,
      required this.pid,
      required this.specialty,
      required this.doctorId,
      required this.url});

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late StreamController<List<dynamic>> _messagesStreamController;
  final Duration _pollInterval =
      const Duration(seconds: 3); // Fetch messages every 3 seconds

  @override
  void initState() {
    super.initState();
    _messagesStreamController = StreamController<List<dynamic>>();
    _startMessageStream();
  }

  @override
  void dispose() {
    _messagesStreamController.close();
    super.dispose();
  }

  Future<void> sendMessage(String message) async {
    if (message.isNotEmpty) {
      const String apiUrl =
          'https://cancerdetection.tech/api/api/sendMessagePatientDoctor.php';

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'sender_id': widget.pid.toString(),
            'receiver_id': widget.doctorId.toString(),
            'message': message,
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          if (responseData['status'] == 'success') {
            _messageController.clear();
            fetchMessages(); // Trigger message fetch after sending
          } else {
            _showSnackbar('Failed to send message: ${responseData['message']}');
          }
        } else {
          _showSnackbar('Error: ${response.statusCode}');
        }
      } catch (e) {
        _showSnackbar('Error occurred: $e');
      }
    }
  }

  void _startMessageStream() {
    Timer.periodic(_pollInterval, (timer) => fetchMessages());
  }

  Future<void> fetchMessages() async {
    const String apiUrl =
        'https://cancerdetection.tech/api/api/getchatlist.php';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'sender_id': widget.pid.toString(),
          'receiver_id': widget.doctorId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          _messagesStreamController.add(responseData['data']);
        } else {
          _messagesStreamController.add([]);
        }
      } else {
        _messagesStreamController.add([]);
      }
    } catch (e) {
      print('Error occurred: $e');
      _messagesStreamController.add([]);
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
        title: ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(widget.url)),
          title: Text(
            widget.doctorName,
            style: GoogleFonts.urbanist(
                fontSize: 16.sp, fontWeight: FontWeight.w700, color: textColor),
          ),
          subtitle: Text(
            widget.specialty,
            style: GoogleFonts.urbanist(
                fontSize: 14.sp, fontWeight: FontWeight.w400, color: greyColor),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<dynamic>>(
              stream: _messagesStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No messages yet.",
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var messageData = messages[index];
                    bool isMe =
                        messageData['sender_id'] == widget.pid.toString();

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
                          if (messageData['message'] != null &&
                              messageData['message'] != '')
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    isMe ? Colors.blueAccent : Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                messageData['message'],
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
                  onPressed: () {
                    sendMessage(_messageController.text.trim());
                  },
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
