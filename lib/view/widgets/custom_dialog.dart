import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialog {
  static void showCustomDialog({
    required String title,
    required String subTitle,
  }) {
    Get.defaultDialog(
      title: title,
      middleText: subTitle,
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontFamily: 'OpenSans', ),
      middleTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400,fontFamily: 'OpenSans',),
    );
  }
}