import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:healthcare/connect.dart';
import 'package:healthcare/views/Book1/Book1.dart';
import 'package:healthcare/views/Resigtration/Login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/Book1/Book6.dart';
import 'package:healthcare/views/widgets/custom_button.dart';
import 'package:intl/intl.dart'; // Importing intl package for date formatting

Map<String, dynamic>? paymentIntent;

class PaymobService {
  final String apiKey =
      'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRVNU16QXhMQ0p1WVcxbElqb2lhVzVwZEdsaGJDSjkuRkRkTTEtNWdRb1dPSXAzVkdTeUgzczltSExKZUNmSHlmdE1lbnh6amZDN0ZJSFc4WlRMNHpHN0ljQkFjMEYxSjc0eHlIZzE3M21LYmZ0RFVKYXVubEE='; // Replace with your Paymob API Key
  final String integrationId = '182841'; // Replace with Integration ID
  final String authUrl = 'https://pakistan.paymob.com/api/auth/tokens';
  final String orderUrl = 'https://pakistan.paymob.com/api/ecommerce/orders';
  final String paymentKeyUrl =
      'https://pakistan.paymob.com/api/acceptance/payment_keys';

  Future<String> authenticate() async {
    var response = await http.post(
      Uri.parse(authUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'api_key': apiKey}),
    );

    if (response.statusCode == 201) {
      var data = jsonDecode(response.body);
      return data['token'];
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  Future<String> createOrder(String authToken, double amount) async {
    var response = await http.post(
      Uri.parse(orderUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({
        "auth_token": authToken,
        "delivery_needed": false,
        "amount_cents": (amount * 100).toInt(), // amount in cents
        "currency": "PKR",
        "items": [],
      }),
    );

    if (response.statusCode == 201) {
      var data = jsonDecode(response.body);
      return data['id'].toString(); // Order ID
    } else {
      throw Exception('Failed to create order');
    }
  }

  Future<String> generatePaymentKey(
      String authToken, String orderId, double amount) async {
    var response = await http.post(
      Uri.parse(paymentKeyUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({
        "auth_token": authToken,
        "amount_cents": (amount * 100).toInt(),
        "expiration": 3600, // 1-hour expiration
        "order_id": orderId,
        "billing_data": {
          "first_name": "John",
          "last_name": "Doe",
          "phone_number": "+923047335002",
          "email": "john.doe@example.com",
          "city": "Lahore",
          "country": "PK",
          "street": "123 Main St",
          "building": "1", // Add building number if necessary
          "floor": "2", // Add floor number if necessary
          "apartment": "10", // Add apartment number if necessary
          "postal_code": "54000", // Add postal code if necessary
          "extra_description": "", // Add any extra description if needed
          "shipping_method": "PK" // Add valid shipping method if required
        },
        "currency": "PKR",
        "integration_id": integrationId,
      }),
    );

    if (response.statusCode == 201) {
      var data = jsonDecode(response.body);
      return data['token']; // Payment Key
    } else {
      throw Exception('Failed to generate payment key');
    }
  }

  Future<void> processPayment(double amount) async {
    String authToken = await authenticate();
    String orderId = await createOrder(authToken, amount);
    String paymentKey = await generatePaymentKey(authToken, orderId, amount);

    // Now use this payment key to integrate JazzCash via Paymob
    // Send paymentKey to the Paymob payment page.
  }
}

class BookingStepFive extends StatefulWidget {
  final DateTime selectedDate; // Date passed from the previous screen
  final String
      selectedTime; // Time passed from the previous screen in hh:mm AM/PM format
  final String selectedDisease; // Disease passed from the previous screen

  const BookingStepFive({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedDisease,
  }) : super(key: key);

  @override
  State<BookingStepFive> createState() => _BookingStepFiveState();
}

class _BookingStepFiveState extends State<BookingStepFive> {
  Future<void> createAppointment({
    required String patientId,
    required String doctorId,
    required String day,
    required String startTime,
    required String endTime,
    required String name,
    required String phone,
    required String hospitalName,
    required String feesdoc,
    String? problem,
    String? meetingLink,
    int status = 0,
    String appointmentStatus = 'waiting',
  }) async {
    const String apiUrl = Api.sendappointment;

    // Data to be sent in the POST request
    Map<String, dynamic> postData = {
      'patient_id': patientId,
      'doctor_id': doctorId,
      'day': day,
      'start_time': startTime,
      'end_time': endTime,
      'name': name,
      'phone': phone,
      'problem': problem ?? '',
      'hospital_name': hospitalName,
      'fees': fees,
      'meeting_link': meetingLink ?? '',
      'status': status.toString(),
      'appointment_status': appointmentStatus,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: postData,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          Get.to(() => const BookingStepSix());
          print('Appointment created successfully');
        } else {
          print('Error: ${responseData['message']}');
        }
      } else {
        print(
            'Failed to create appointment. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  final PaymobService paymobService = PaymobService();
  bool isLoading = false;

  Future<void> initiatePayment() async {
    setState(() {
      isLoading = true;
    });

    try {
      await paymobService.processPayment(800.0); // Example: PKR 100
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Payment initiated!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Convert selected time from 12-hour format (08:30 AM) to 24-hour format (08:30:00 or 20:30:00)
  // String convertTo24HourFormat(String time) {
  //   try {
  //     final DateFormat inputFormat =
  //         DateFormat.jm(); // Input format (hh:mm AM/PM)
  //     final DateFormat outputFormat =
  //         DateFormat('HH:mm:ss'); // Output format (24-hour format)

  //     // Remove any leading or trailing whitespace from the time string
  //     time = time.trim();

  //     // Parse the time
  //     final DateTime parsedTime = inputFormat.parse(time);

  //     // Convert to 24-hour format and return
  //     return outputFormat.format(parsedTime);
  //   } catch (e) {
  //     // Handle any parsing errors here
  //     print("Error parsing time: $e");
  //     return "00:00:00"; // Return a default value or handle the error gracefully
  //   }
  // }

  String convertTo24HourFormat(String time) {
    // Remove any extra spaces
    time = time.trim();

    // Check if the time is in AM/PM format
    bool isPM = time.toUpperCase().contains('PM');
    bool isAM = time.toUpperCase().contains('AM');

    // Remove AM/PM from the string
    time = time.toUpperCase().replaceAll('AM', '').replaceAll('PM', '').trim();

    // Split hours and minutes
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    // Convert to 24-hour format
    if (isPM && hours != 12) {
      hours += 12;
    } else if (isAM && hours == 12) {
      hours = 0;
    }

    // Format the time with padding zeros
    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');

    return '$formattedHours:$formattedMinutes:00';
  }

  @override
  Widget build(BuildContext context) {
    // Formatting the date to 'yyyy-MM-dd'
    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDate);

    // Converting selectedTime to 24-hour format
    String convertedTime = convertTo24HourFormat(widget.selectedTime);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 12.h,
              ),
              Container(
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 32,
                    )),
              ),
              SizedBox(
                height: 22.h,
              ),
              Text(
                "Summary",
                style: GoogleFonts.urbanist(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor),
              ),
              SizedBox(
                height: 77.h,
              ),
              Text(
                "Booking Info",
                style: GoogleFonts.urbanist(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor),
              ),
              SizedBox(
                height: 22.h,
              ),
              ListTile(
                leading: Container(
                    width: 42.w,
                    height: 42.h,
                    padding: const EdgeInsets.all(6.0),
                    decoration: const BoxDecoration(
                        color: silverColor, shape: BoxShape.circle),
                    child: const SvgIcon(
                        icon: SvgIconData("assets/icons/calender-icon.svg"))),
                title: Text(
                  "Date & Time",
                  style: GoogleFonts.urbanist(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor),
                ),
                subtitle: Text(
                  "${DateFormat('EEEE').format(widget.selectedDate)}, $formattedDate\n${widget.selectedTime}",
                  style: GoogleFonts.urbanist(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: greyColor),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              const Divider(
                color: silverColor,
              ),
              SizedBox(
                height: 124.h,
              ),
              Text(
                "Doctor Info",
                style: GoogleFonts.urbanist(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor),
              ),
              SizedBox(
                height: 12.h,
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundImage:
                      AssetImage("assets/images/doctor-nirmala.png"),
                ),
                title: Text(
                  "$dname",
                  style: GoogleFonts.urbanist(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$dspecial",
                      style: GoogleFonts.urbanist(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: greyColor),
                    ),
                    Container(
                      width: 83.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                          color: lightgreenColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Expanded(
                          child: Text(
                            widget.selectedDisease,
                            style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: greenColor),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 130.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: GoogleFonts.urbanist(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor),
                  ),
                  Text(
                    "PKR $fees",
                    style: GoogleFonts.urbanist(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: blackColor),
                  )
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              CustomButton(
                text: "Pay Now",
                onPressed: makePayment,
                // onPressed: () {

                //   createAppointment(
                //     patientId: id.toString(), // Replace with actual patient ID
                //     doctorId: did.toString(), // Replace with actual doctor ID
                //     day: formattedDate,
                //     startTime: convertedTime, // Use the converted time
                //     endTime:
                //         convertedTime, // You can modify this to have different start and end times
                //     name: userName, // Replace with actual patient name
                //     phone:
                //         '123456789', // Replace with actual patient phone number
                //     hospitalName:
                //         'XYZ Hospital', // Replace with actual hospital name
                //     fees: '100', // Replace with actual fees
                //     problem: widget.selectedDisease, // The selected disease
                //   );

                // },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> makePayment() async {
  //   try {
  //     String amount =
  //         '800'; // Change this to the actual amount you want to charge

  //     // Create the payment intent with the amount and currency
  //     paymentIntent = await createPaymentIntent(fees, 'PKR');

  //     await Stripe. instance.initPaymentSheet(
  //         paymentSheetParameters: SetupPaymentSheetParameters(
  //             paymentIntentClientSecret: paymentIntent!['client_secret'],
  //             style: ThemeMode.dark,
  //             merchantDisplayName: 'Ikay'));

  //     displayPaymentSheet();
  //   } catch (err) {
  //     print('Error during makePayment: $err');
  //   }
  // }

  Future<void> makePayment() async {
    try {
      // Create the payment intent
      paymentIntent = await createPaymentIntent(fees, 'PKR');

      if (paymentIntent == null) {
        throw Exception('Failed to create payment intent');
      }

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          merchantDisplayName: 'IKay',
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              background: Colors.white,
              primary: Colors.blue,
            ),
          ),
        ),
      );

      await displayPaymentSheet();
    } catch (err) {
      print('Error in makePayment: $err');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${err.toString()}')),
      );
    }
  }

  // displayPaymentSheet() async {
  //   try {
  //     String formattedDate =
  //         DateFormat('yyyy-MM-dd').format(widget.selectedDate);
  //     String convertedTime = convertTo24HourFormat(widget.selectedTime);

  //     await Stripe.instance.presentPaymentSheet().then((value) {
  //       showDialog(
  //         context: context,
  //         builder: (_) => const AlertDialog(
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Icon(
  //                 Icons.check_circle,
  //                 color: Colors.green,
  //                 size: 100.0,
  //               ),
  //               SizedBox(height: 10.0),
  //               Text("Payment Successful!"),
  //             ],
  //           ),
  //         ),
  //       ).then((_) {
  //         paymentIntent = null;
  //         createAppointment(
  //           patientId: id.toString(), // Replace with actual patient ID
  //           doctorId: did.toString(), // Replace with actual doctor ID
  //           day: formattedDate,
  //           startTime: convertedTime, // Use the converted time
  //           endTime:
  //               convertedTime, // You can modify this to have different start and end times
  //           name: userName, // Replace with actual patient name
  //           phone: '123456789', // Replace with actual patient phone number
  //           hospitalName: 'XYZ Hospital', // Replace with actual hospital name
  //           feesdoc: '1000', // Replace with actual fees
  //           problem: widget.selectedDisease, // The selected disease
  //         );
  //       });
  //     }).onError((error, stackTrace) {
  //       print('Error during displayPaymentSheet: $error');
  //       // Instead of AlertDialog, show a SnackBar for payment cancellation or failure
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text("Payment Cancelled"),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     });
  //   } catch (e) {
  //     print('Unexpected error: $e');
  //   }
  // }

  String convertAndAddTime(String time) {
    // Remove any extra spaces
    time = time.trim();

    // Check if the time is in AM/PM format
    bool isPM = time.toUpperCase().contains('PM');
    bool isAM = time.toUpperCase().contains('AM');

    // Remove AM/PM from the string
    time = time.toUpperCase().replaceAll('AM', '').replaceAll('PM', '').trim();

    // Split hours and minutes
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    // Convert to 24-hour format
    if (isPM && hours != 12) {
      hours += 12;
    } else if (isAM && hours == 12) {
      hours = 0;
    }

    // Add 20 minutes
    minutes += 20;

    // Handle minute overflow
    if (minutes >= 60) {
      hours += minutes ~/ 60; // Add extra hours
      minutes = minutes % 60; // Keep remaining minutes
    }

    // Handle hour overflow
    if (hours >= 24) {
      hours = hours % 24;
    }

    // Format the time with padding zeros
    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');

    return '$formattedHours:$formattedMinutes:00';
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      // Format date and time
      String formattedDate =
          DateFormat('yyyy-MM-dd').format(widget.selectedDate);
      String convertedTime = convertTo24HourFormat(widget.selectedTime);
      String endtime = convertAndAddTime(widget.selectedTime);

      // Show success dialog
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100.0,
              ),
              SizedBox(height: 10.0),
              Text("Payment Successful!"),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                // Create appointment after successful payment
                createAppointment(
                  patientId: id.toString(),
                  doctorId: did.toString(),
                  day: formattedDate,
                  startTime: convertedTime,
                  endTime: endtime,
                  name: userName,
                  phone: '123456789',
                  hospitalName: 'XYZ Hospital',
                  feesdoc: fees,
                  problem: widget.selectedDisease,
                );
              },
            ),
          ],
        ),
      );

      paymentIntent = null;
    } catch (e) {
      print('Error in displayPaymentSheet: $e');
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.error.localizedMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // createPaymentIntent(String amount, String currency) async {
  //   try {
  //     Map<String, dynamic> body = {
  //       'amount': calculateAmount(amount),
  //       'currency': currency,
  //     };

  //     var response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       headers: {
  //         'Authorization':
  //             'Bearer sk_test_51MtZ0fHHWmQC05Mfmf2b75TUfgWKUZZ1bKdAopFlDbFqlLnt2SlFzM04vUvQrzI1qDKIzqxgxOOIhbrNjP1rbQSp004wSAoHk9',
  //         'Content-Type': 'application/x-www-form-urlencoded'
  //       },
  //       body: body,
  //     );

  //     if (response.statusCode == 200) {
  //       return json.decode(response.body);
  //     } else {
  //       throw Exception('Failed to create payment intent');
  //     }
  //   } catch (err) {
  //     print('Error during createPaymentIntent: $err');
  //     throw Exception(err.toString());
  //   }
  // }

  Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) async {
    try {
      // Calculate amount in smallest currency unit
      final calculatedAmount = (double.parse(amount) * 100).round().toString();

      // Prepare the body of the request
      Map<String, dynamic> body = {
        'amount': calculatedAmount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      // Make the API request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51Q1nGrFHugyQIn2JHZlhRarixRFCOqlbsNrOZ9BdwtrVbkD5b8G66lu151uRL73zlA07SBdvd5OTo9DMV5W6Q6U500vY4cvOil', // Replace with your actual Stripe secret key
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      print('Payment Intent Response: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print(
            'Failed to create payment intent. Status: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (err) {
      print('Error in createPaymentIntent: $err');
      return null;
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
