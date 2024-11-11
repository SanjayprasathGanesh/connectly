import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class CustomToast {
  static void showToast({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
  }) {
    Toast.show(
      message,
      duration: 3,
      gravity: Toast.bottom,
      backgroundColor: backgroundColor,
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        fontFamily: 'OpenSans',
      ),
    );
  }
}
