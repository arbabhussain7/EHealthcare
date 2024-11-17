import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/views/Resigtration/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/profile/profile_screen.dart';
import 'package:healthcare/views/widgets/custom_button.dart';
import 'package:healthcare/views/widgets/profile_textfield.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({super.key});

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  int _groupValue = -1;

  // Controllers for text fields
  final TextEditingController _ehealthcareIdController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAccountDetails(); // Load existing values from SharedPreferences
  }

  // Load data from SharedPreferences
  Future<void> _loadAccountDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstNameController.text = prefs.getString('firstName') ?? '';
      _lastNameController.text = prefs.getString('lastName') ?? '';
      _dobController.text = prefs.getString('dob') ?? '';
      _phoneNumberController.text = prefs.getString('phoneNumber') ?? '';

      _cityController.text = prefs.getString('city') ?? '';
      _provinceController.text = prefs.getString('province') ?? '';
      _addressController.text = prefs.getString('address') ?? '';

      String gender = prefs.getString('gender') ?? '';
      _groupValue = (gender == 'Male') ? 0 : 1; // Setting radio button value
    });
  }

  // Save data to SharedPreferences
  Future<void> _saveAccountDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ehealthcareId', _ehealthcareIdController.text);
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('firstName', _firstNameController.text);
    await prefs.setString('lastName', _lastNameController.text);
    await prefs.setString('dob', _dobController.text);
    await prefs.setString('phoneNumber', _phoneNumberController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('city', _cityController.text);
    await prefs.setString('province', _provinceController.text);
    await prefs.setString('address', _addressController.text);
    await prefs.setString('gender', (_groupValue == 0) ? 'Male' : 'Female');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: SingleChildScrollView(
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
                          "Edit Account",
                          style: GoogleFonts.montserrat(
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
                SizedBox(
                  height: 22.h,
                ),
                Text(
                  "Personal",
                  style: GoogleFonts.urbanist(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: greyColor),
                ),
                SizedBox(
                  height: 22.h,
                ),
                ProfileTextField(
                  text: "Ehealthcare Id",
                  inputtext: TextInputType.number,
                  controller: TextEditingController(text: id.toString()),
                ),
                SizedBox(
                  height: 15.h,
                ),
                ProfileTextField(
                  text: "Username",
                  inputtext: TextInputType.text,
                  controller: TextEditingController(text: userName),
                ),
                SizedBox(
                  height: 15.h,
                ),
                ProfileTextField(
                  text: "First Name",
                  inputtext: TextInputType.text,
                  controller: _firstNameController,
                ),
                SizedBox(
                  height: 15.h,
                ),
                ProfileTextField(
                  text: "Last Name",
                  inputtext: TextInputType.text,
                  controller: _lastNameController,
                ),
                SizedBox(
                  height: 15.h,
                ),
                ProfileTextField(
                  text: "Date of Birth",
                  inputtext: TextInputType.text,
                  controller: _dobController,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gender",
                        style: GoogleFonts.urbanist(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: greyColor),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: RadioListTile(
                              value: 0,
                              groupValue: _groupValue,
                              title: const Text("Male"),
                              onChanged: (newValue) =>
                                  setState(() => _groupValue = newValue!),
                              activeColor: cyanColor,
                              selected: false,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: RadioListTile(
                              value: 1,
                              groupValue: _groupValue,
                              title: const Text("Female"),
                              onChanged: (newValue) =>
                                  setState(() => _groupValue = newValue!),
                              activeColor: cyanColor,
                              selected: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    "Contact",
                    style: GoogleFonts.urbanist(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: greyColor),
                  ),
                ),
                ProfileTextField(
                    text: "Type your phone number",
                    inputtext: TextInputType.number,
                    controller: _phoneNumberController),
                SizedBox(
                  height: 22.h,
                ),
                ProfileTextField(
                  text: "Type your email",
                  inputtext: TextInputType.emailAddress,
                  controller: TextEditingController(text: emailController.text),
                ),
                SizedBox(
                  height: 22.h,
                ),
                ProfileTextField(
                    text: "City",
                    inputtext: TextInputType.text,
                    controller: _cityController),
                SizedBox(
                  height: 22.h,
                ),
                ProfileTextField(
                    text: "Province",
                    inputtext: TextInputType.text,
                    controller: _provinceController),
                SizedBox(
                  height: 22.h,
                ),
                ProfileTextField(
                    text: "Address",
                    inputtext: TextInputType.text,
                    controller: _addressController),
                SizedBox(
                  height: 22.h,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: whiteColor,
        child: CustomButton(
            text: "Save Changes",
            onPressed: () async {
              await _saveAccountDetails(); // Save changes to SharedPreferences
              Get.offAll(() => const ProfileScreen());
            }),
      ),
    );
  }

  @override
  void dispose() {
    _ehealthcareIdController.dispose();
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
