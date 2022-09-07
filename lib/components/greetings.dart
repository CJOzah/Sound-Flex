
import 'package:flutter/material.dart';

import '../utils/colors.dart';
Widget greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 
        const Text('Good morning' ,
        style: TextStyle(
          color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato'
        ),
        );
  }
  if (hour < 17) {
    return 
        const Text('Good afternoon',
        style: TextStyle(
          color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato'
        ),);
  }
  return 
      const Text('Good evening',
        style: TextStyle(
          color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato'
        ),);
}