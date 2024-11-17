import 'package:flutter/material.dart';

class booking extends StatefulWidget {
  const booking({super.key});

  @override
  State<booking> createState() => _bookingState();
}

class _bookingState extends State<booking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Row(children: [
                  Container(
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                  ),
                  const SizedBox(
                    width: 83,
                  ),
                  Container(
                    child: const Text(
                      "Booking Detail",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  )
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child: const Text(
                        "Booking Info",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      )),
                      Container(
                        width: 114,
                        height: 24,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(128, 141, 158, 1),
                            borderRadius: BorderRadius.circular(4)),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 2, left: 5),
                          child: Text(
                            "Pending Payment",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: Container(
                width: 335,
                height: 206,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(248, 248, 251, 1),
                    // border: Border.all(),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Stack(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 23, left: 15),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  // border: Border.all(),
                                  borderRadius: BorderRadius.circular(22)),
                              width: 42,
                              height: 42,
                              child: const Icon(Icons.credit_card)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 23, left: 68),
                          child: Container(
                            child: const Text(
                              "Date & Time",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 43, left: 68),
                          child: Container(
                            child: const Text(
                              "Monday, 20 Jun 2022",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(128, 141, 158, 1)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 63, left: 68),
                          child: Container(
                            child: const Text(
                              "08:00 AM",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(128, 141, 158, 1)),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 22),
                      child: Divider(
                        endIndent: 18,
                      ),
                    ),
                    Container(
                      child: Stack(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 23, left: 15),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(72, 189, 105, 1),
                                  // border: Border.all(),
                                  borderRadius: BorderRadius.circular(22)),
                              width: 42,
                              height: 42,
                              child: const Icon(
                                Icons.airline_stops_sharp,
                                color: Colors.white,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 23, left: 68),
                          child: Container(
                            child: const Text(
                              "Appointment Type",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 43, left: 68),
                          child: Container(
                            child: const Text(
                              "Video Call",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(128, 141, 158, 1)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 63, left: 68),
                          child: Container(
                            child: const Text(
                              "None",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(128, 141, 158, 1)),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 252),
              child: Container(
                child: const Text(
                  "Doctor Info",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                width: 335,
                height: 111,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    // border: Border.all(),
                    borderRadius: BorderRadius.circular(7)),
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 22,
                    ),
                    child: Container(
                      child: CircleAvatar(
                        child: Image.asset("Image/appointment.png"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 23, left: 48),
                    child: Container(
                      child: const Text(
                        "Dr. Nirmala Azalea",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 43, left: 48),
                    child: Container(
                      child: const Text(
                        "Surgery",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(128, 141, 158, 1)),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            const SizedBox(
              height: 152,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: const Text(
                          "Total Price",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        child: const Text(
                          "Rs. 1220",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w700),
                        ),
                      )
                    ]),
              ),
            ),
            SizedBox(
              width: 365,
              height: 48,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.cyan, // background color
                    // onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2), // button's shape
                    ),
                  ),
                  child: const Text(
                    "Pay Now",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
