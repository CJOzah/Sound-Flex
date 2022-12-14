import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sound_flex/components/sf_gradient_splash_background.dart';
import 'package:sound_flex/gen/assets.gen.dart';
import 'package:sound_flex/screens/home_screen.dart';
import 'package:sound_flex/utils/colors.dart';
import 'package:sound_flex/utils/size_config.dart';
import 'package:sound_flex/view_models/manager.dart';

import '../view_models/auth_provider.dart';

class MusicDetails extends StatefulWidget {
  const MusicDetails({Key? key,required this.pageManager}) : super(key: key);
 final PageManager pageManager;
  @override
  State<MusicDetails> createState() => _MusicDetailsState();
}

class _MusicDetailsState extends State<MusicDetails> {
 
  @override
  Widget build(BuildContext context) {
  
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    SizeConfig().init(context);
    return SfGradientSplashBackground(
      
      appColors: Colors.transparent,
      isLoading: authProvider.loading,
      scaffold: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 30),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Center(
                    child: Text(
                      "Music",
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: AppColors.white,
                          ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 30,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(SizeConfig.screenWidth * 0.2),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(SizeConfig.screenHeight * 0.1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey.shade600,
                ),
                child: Assets.images.disc.image(
                  height: 170,
                  width: 170,
                ),
              ),
              Gap(SizeConfig.screenWidth * 0.15),
              Center(
                child: Text(
                  (widget.pageManager.indexSelected == null)
                      ? ""
                      : authProvider
                          .songList!.entries![widget.pageManager.indexSelected!].name!,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: AppColors.white,
                      ),
                ),
              ),
              Gap(SizeConfig.screenWidth * 0.22),
              bottomPanel(
                  isDarkMode: true,
                  context: context,
                  pageManager: widget.pageManager.pageManager),
            ],
          ),
        ),
      ),
    );
  }
}
