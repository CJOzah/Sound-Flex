import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';
import '../../../utils/strings.dart';


class SuccessBottomSheet extends StatefulWidget {

  const SuccessBottomSheet({
    Key? key,
   
  }) : super(key: key);

  @override
  State<SuccessBottomSheet> createState() => _SuccessBottomSheetState();
}

class _SuccessBottomSheetState extends State<SuccessBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  String otp = "";
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 40),
          child: SingleChildScrollView(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              alignment: WrapAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(20),
                Container(
                  height: 3,
                  width: 115,
                  color: AppColors.primaryDart,
                ),
                      const Gap(20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: 
                      Stack(
                        children: [InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20,)),
                      const Gap(3),
                          // Align(
                          //   alignment: Alignment.center,
                          //   child: Assets.svgs.successIcon.svg()),
                        ],
                      ),
                ),
                const Gap(15),
                
                      const Text(
                        "Congratulations",
                        style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                        color: AppColors.black,
                        fontFamily: 'Inter',
                      ),
                      ),
                      const Gap(5),
                      Text(
                        subscriptionSuccessMess,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppColors.primaryDart,
                        fontFamily: 'Inter',
                      ),
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
