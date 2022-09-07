import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ToastService {
  showSuccess(BuildContext context, String? title, String message) {
    Flushbar(
      backgroundColor: Colors.green.shade800,
      duration: const Duration(seconds: 3),
      title: title,
      message: message,
    ).show(context);
  }

  showError(BuildContext context, String? title, String message) {
    Flushbar(
      backgroundColor: Colors.red.shade800,
      duration: const Duration(seconds: 3),
      title: title,
      message: message,
    ).show(context);
  }
}
