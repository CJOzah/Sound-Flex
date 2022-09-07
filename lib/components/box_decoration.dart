import 'package:flutter/material.dart';
BoxDecoration allowBox(double radius,Color appColors){
  return  BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
      border: Border.all(width: 0.5,color: appColors)
  );
}
