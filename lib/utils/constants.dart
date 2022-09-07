// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sound_flex/utils/colors.dart';
import 'package:validators/validators.dart';


double scaledFontSize(BuildContext context, size) {
  // final mediaQueryData = MediaQuery.of(context);
  //final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.3);
  return Platform.isAndroid
      ? (size - 1) * MediaQuery.of(context).textScaleFactor
      : size * MediaQuery.of(context).textScaleFactor;
}

double sizeTextHeaderSet(context, customSize){
  double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
  return customSize*unitHeightValue;
}

String? checkNullField(Map<String, String> formFields) {
  for (final MapEntry formField in formFields.entries) {
    if (isNull(formField.value)) {
      return formField.key;
    }
  }
  return null;
}

void showLoader(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);

  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
  showDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0.6),
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child:  Container(
                height: 60,
                alignment: FractionalOffset.center,
                child: const SpinKitDoubleBounce(
                  color: AppColors.primary,
                  size: 60.0,
                )));
      });
}

void showTransparentLoader(BuildContext context) {
  showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child:  Container(
                height: 60,
                alignment: FractionalOffset.center,
                child: const SpinKitDoubleBounce(
                  color: AppColors.primary,
                  size: 60.0,
                )));
      });
}


String formatDate(String timeStamp) {
  return DateFormat.yMMMd().format(DateTime.parse(timeStamp));
}

String formatTime(String timeStamp) {
  return DateFormat("h:mm a").format((DateTime.parse(timeStamp)));
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

String formatAmount(dynamic digits) {
  final digitsFormat = NumberFormat("#,###", "en_US");
  var withDecimalPoint = digits.toStringAsFixed(2);
  var split = withDecimalPoint.split(".");
  var formattedInt =
      digitsFormat.format(int.parse(split[0])) + "." + split[1];
  return formattedInt;
}

Widget showLoadingView() {
  return const SpinKitDoubleBounce(
    color: AppColors.primary,
    size: 60.0,
  );
}


extension ModifiedString on String {
  String lastCharacters(int n) => substring(length - n);
}

    
