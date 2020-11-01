import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class CustomLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinKitChasingDots(
          color: Get.theme.primaryColor,
          size: 30,
        ),
        SizedBox(
          height: 10,
        ),
        Text("Please wait"),
      ],
    );
  }
}
