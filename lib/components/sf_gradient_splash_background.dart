import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

class SfGradientSplashBackground extends StatelessWidget {

  final Scaffold scaffold;
  final Color appColors;
  final bool? isLoading;
  const SfGradientSplashBackground({Key? key,required this.scaffold, required this.appColors, this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   LoadingOverlay(
      progressIndicator: SizedBox(
        height: 80,
        width: 80,
        child:  Lottie.asset('assets/images/loadingAnim.json'),
      ),
      isLoading: isLoading ?? false,
      child: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [-0.15, 0.20, 0.47, 0.85, 1.9],
            colors:
            [
              appColors,
              appColors,
              appColors,
              appColors,
              appColors,
            ],
          ),
        ),
        child: scaffold,
      ),
    );
  }
}
