import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'dart:math' as math;

class Chat extends StatelessWidget {
  Chat({super.key, required this.callingId});
  final String callingId;
  final String localUserID = math.Random().nextInt(10000).toString();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ZegoUIKitPrebuiltCall(
            appID: 819235364,
            callID: callingId,
            appSign:
                "cf3f8deb38c00ef6c4097c1ef6758e4ce48dac5f2473833f4a86de0464532f02",
            userID: localUserID,
            userName: 'user_$localUserID',
            config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()));
  }
}
