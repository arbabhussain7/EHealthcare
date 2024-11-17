import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import '../connect.dart';
import '../models/patient.dart';
import '../views/BottomNavBar/bottom_Navbar.dart';

class AuthVm extends GetxController {
  Patient patient = Patient();
  RxBool isLoading = false.obs;

  Future<void> login({String email = "", String password = ""}) async {
    isLoading.value = true;
    try {
      final url = Uri.parse(Api.login);
      final response =
          await http.post(url, body: {'email': email, 'password': password});

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['id'] != null) {
          patient = Patient.fromJson(responseData);

          Get.offAll(const BottomNavBar());
          debugPrint('Patient id: ${patient.id}');
        } else {
          debugPrint('Invalid credentials or no data found');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      debugPrint('An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  ////////////////////////////////////////////////////////////////////

  //
}
