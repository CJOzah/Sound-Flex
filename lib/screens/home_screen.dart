// ignore_for_file: unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:sound_flex/components/common.dart';
import 'package:sound_flex/components/music_details.dart';
import 'package:sound_flex/components/music_widget.dart';
import 'package:sound_flex/components/sf_gradient_splash_background.dart';
import 'package:sound_flex/gen/assets.gen.dart';
import 'package:sound_flex/utils/constants.dart';
import 'package:sound_flex/utils/size_config.dart';
import 'package:sound_flex/utils/toasts.dart';
import 'package:sound_flex/view_models/auth_provider.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:flutter/services.dart';
import 'package:audio_session/audio_session.dart';
import 'package:sound_flex/view_models/manager.dart';
import '../AppUrl/app_url.dart';
import '../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late final PageManager _pageManager;

  @override
  void initState() {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    // ignore: prefer_function_declarations_over_variables
    var songList = () async {
      final Map<String, dynamic> getSongList = {
        "include_deleted": false,
        "include_has_explicit_shared_members": false,
        "include_media_info": true,
        "include_mounted_folders": true,
        "include_non_downloadable_files": true,
        "path": "/File requests/music",
        "recursive": false
      };
      final Future<Map<String, dynamic>> respose =
          authProvider.postRequest(getSongList, AppUrl.listFolder);
      respose.then((response) {
        if (response['status'] == null) {
          ToastService().showError(context, 'Failed', response['message']);
        }
        if (response['status'] == true) {
          // Get.offAll(() => BottomNavHost());
          ToastService().showSuccess(context, 'Success', response['message']);
        } else {
          ToastService().showError(context, 'Failed', response['message']);
        }
      });
    };

    // ignore: prefer_function_declarations_over_variables
    var getBearer = () async {
      final Map<String, dynamic> getBearerToken = {
        "refresh_token":
            "rxwUiSX2a9UAAAAAAAAAAZAC8zwG79cK9t4zRfWIkDHr44wVJZII9-q3e41odAnq",
        "grant_type": "refresh_token",
        "client_id": "hxwueslwhk1oxee",
        "client_secret": "3pvz3p5lse4pxqf"
      };
      final Future<Map<String, dynamic>> respose =
          authProvider.postRequest(getBearerToken, AppUrl.token);
      respose.then((response) {
        if (response['status'] == null) {
          ToastService().showError(context, 'Failed', response['message']);
        }
        if (response['status'] == true) {
          songList();
          ToastService().showSuccess(context, 'Success', response['message']);
        } else {
          ToastService().showError(context, 'Failed', response['message']);
        }
      });
    };

    getBearer();
    super.initState();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);

    _pageManager = PageManager();
    _pageManager.setPageManager(_pageManager);
  }

  bool isPlaying = false;
  num curIndex = 0;
  final _player = AudioPlayer();
  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    _pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    // ignore: prefer_function_declarations_over_variables
    var tempLink = (String path) async {
      final Map<String, dynamic> getTempLink = {"path": path};
      final Future<Map<String, dynamic>> respose =
          authProvider.postRequest(getTempLink, AppUrl.tempLink);
      respose.then((response) async {
        if (response['status'] == null) {
          ToastService().showError(context, 'Failed', response['message']);
        }
        if (response['status'] == true) {
          //  _pageManager = PageManager(context);
          _pageManager.play();
          ToastService().showSuccess(context, 'Success', response['message']);
        } else {
          ToastService().showError(context, 'Failed', response['message']);
        }
      });
    };

    return SfGradientSplashBackground(
      appColors: Colors.transparent,
      isLoading: authProvider.loading,
      scaffold: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          )),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Gap(SizeConfig.screenWidth * 0.1),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sound Flex",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                    color: AppColors.white,
                                  ),
                            ),
                            const Gap(10),
                            Text(
                              authProvider.songList == null
                                  ? "0"
                                  : "songs ${authProvider.songList!.entries!.length}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: AppColors.white,
                                    fontSize: scaledFontSize(context, 15),
                                  ),
                            ),
                            const Gap(20),
                            Align(
                                alignment: Alignment.centerRight,
                                child: PlayButton(
                                  isShuffle: true,
                                  pageManager: _pageManager,
                                  width: 50,
                                )),
                          ],
                        ),
                      ),
                      if (authProvider.songList != null)
                        SongWidget(
                          songList: authProvider.songList,
                          pageManager: _pageManager,
                        ),
                    ],
                  ),
                ),
                _buildBottomBar(context, authProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildBottomBar(BuildContext context, AuthProvider authProvider) {
    return Container(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          String? result = await showModalBottomSheet<String>(
              context: context,
              isDismissible: false,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
              ),
              isScrollControlled: true,
              builder: (builder) => MusicDetails(
                    pageManager: _pageManager,
                  ));
        },
        child: Card(
          color: Colors.transparent,
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: ClipRRect(
                      child: Assets.images.disc.image(
                        height: 40,
                        width: 40,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  _pageManager.indexSelected == null
                                      ? "Unknown"
                                      : authProvider
                                          .songList!
                                          .entries![_pageManager.indexSelected!]
                                          .name!,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: scaledFontSize(context, 13),
                                      fontWeight: FontWeight.w700)),
                              const Gap(10),
                              Text(
                                  _pageManager.indexSelected == null
                                      ? "Unknown"
                                      : "Unknown",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: scaledFontSize(context, 11),
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColors.primary,
                            ),
                            child: Center(
                              child: ValueListenableBuilder<ButtonState>(
                                valueListenable: _pageManager.buttonNotifier,
                                builder: (_, value, __) {
                                  switch (value) {
                                    case ButtonState.loading:
                                      return Stack(
                                        children: [
                                          const CircularProgressIndicator(),
                                          IconButton(
                                            icon: const Icon(Icons.pause),
                                            iconSize: 30.0,
                                            color: AppColors.primary,
                                            onPressed: _pageManager.pause,
                                          ),
                                        ],
                                      );
                                    case ButtonState.paused:
                                      return IconButton(
                                        icon: const Icon(Icons.play_arrow),
                                        iconSize: 30.0,
                                        color: AppColors.white,
                                        onPressed: () => _pageManager.play(),
                                      );
                                    case ButtonState.playing:
                                      return IconButton(
                                        icon: const Icon(Icons.pause),
                                        iconSize: 30.0,
                                        color: AppColors.white,
                                        onPressed: _pageManager.pause,
                                      );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool showVol = false;
}

class PlayButton extends StatelessWidget {
  const PlayButton({
    Key? key,
    required PageManager pageManager,
    this.width,
    this.isShuffle,
  })  : _pageManager = pageManager,
        super(key: key);

  final PageManager _pageManager;
  final double? width;
  final bool? isShuffle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: AppColors.primary,
          ),
          child: Center(
            child: ValueListenableBuilder<ButtonState>(
              valueListenable: _pageManager.buttonNotifier,
              builder: (_, value, __) {
                switch (value) {
                  case ButtonState.loading:
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        IconButton(
                          icon: const Icon(Icons.pause),
                          iconSize: 30.0,
                          color: AppColors.primary,
                          onPressed: _pageManager.pause,
                        ),
                      ],
                    );
                  case ButtonState.paused:
                    return IconButton(
                      icon: const Icon(Icons.play_arrow),
                      iconSize: 30.0,
                      color: AppColors.white,
                      onPressed: () => _pageManager.play(),
                    );
                  case ButtonState.playing:
                    return IconButton(
                      icon: const Icon(Icons.pause),
                      iconSize: 30.0,
                      color: AppColors.white,
                      onPressed: _pageManager.pause,
                    );
                }
              },
            ),
          ),
        ),
        if (isShuffle == true)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColors.white,
            ),
            height: 25,
            width: 25,
            child: Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: const Icon(CupertinoIcons.shuffle_thick),
                iconSize: 12.0,
                color: AppColors.primary,
                onPressed: _pageManager.pause,
              ),
            ),
          ),
      ],
    );
  }
}

Widget bottomPanel(
    {required bool isDarkMode,
    required BuildContext context,
    required PageManager pageManager}) {
  AuthProvider authProvider = Provider.of<AuthProvider>(context);
  // ignore: prefer_function_declarations_over_variables
  var tempLink = (String path) async {
    final Map<String, dynamic> getTempLink = {"path": path};
    final Future<Map<String, dynamic>> respose =
        authProvider.postRequest(getTempLink, AppUrl.tempLink);
    respose.then((response) async {
      if (response['status'] == null) {
        ToastService().showError(context, 'Failed', response['message']);
      }
      if (response['status'] == true) {
        //  _pageManager = PageManager(context);
        pageManager.setPlay(context);
        ToastService().showSuccess(context, 'Success', response['message']);
      } else {
        ToastService().showError(context, 'Failed', response['message']);
      }
    });
  };

  void previous(PageManager pageManager, BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    pageManager.stop();
    if (pageManager.indexSelected! == 0) {
      tempLink(authProvider.songList!.entries!.last.pathLower!);
      pageManager.setIndexSelected(authProvider.songList!.entries!.length - 1);
    } else {
      tempLink(authProvider
          .songList!.entries![pageManager.indexSelected! - 1].pathLower!);
      pageManager.setIndexSelected(pageManager.indexSelected! - 1);
    }
  }

  void next(PageManager pageManager, BuildContext context) {
    pageManager.stop();
    if (authProvider.songList!.entries!.length - 1 ==
        pageManager.indexSelected) {
      tempLink(authProvider.songList!.entries![0].pathLower!);
      pageManager.setIndexSelected(0);
    } else {
      tempLink(authProvider
          .songList!.entries![pageManager.indexSelected! + 1].pathLower!);
      pageManager.setIndexSelected(pageManager.indexSelected! + 1);
    }
  }

  return Column(children: <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ValueListenableBuilder<ProgressBarState>(
        valueListenable: pageManager.progressNotifier,
        builder: (_, value, __) {
          return ProgressBar(
            timeLabelPadding: 0,
            timeLabelTextStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: scaledFontSize(context, 14),
                color: isDarkMode ? AppColors.white : AppColors.black),
            timeLabelLocation: TimeLabelLocation.sides,
            thumbRadius: 9.0,
            thumbColor: isDarkMode ? AppColors.white : AppColors.primary,
            progressBarColor:
                isDarkMode ? AppColors.primary : AppColors.primary,
            bufferedBarColor: isDarkMode
                ? AppColors.white.withOpacity(0.5)
                : AppColors.primary.withOpacity(0.5),
            baseBarColor: isDarkMode
                ? AppColors.white.withOpacity(0.2)
                : AppColors.primary.withOpacity(0.2),
            progress: value.current,
            buffered: value.buffered,
            total: value.total,
            onSeek: pageManager.seek,
          );
        },
      ),
    ),
    Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: IconButton(
                icon: const Icon(
                  Icons.skip_previous,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  pageManager.stop();
                  previous(pageManager, context);
                }),
            //  audioManagerInstance.previous()),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColors.primary,
            ),
            child: Center(
              child: ValueListenableBuilder<ButtonState>(
                valueListenable: pageManager.buttonNotifier,
                builder: (_, value, __) {
                  switch (value) {
                    case ButtonState.loading:
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          IconButton(
                            icon: const Icon(Icons.pause),
                            iconSize: 40.0,
                            color: AppColors.primary,
                            onPressed: pageManager.pause,
                          ),
                        ],
                      );
                    case ButtonState.paused:
                      return IconButton(
                        icon: const Icon(Icons.play_arrow),
                        iconSize: 50.0,
                        color: AppColors.white,
                        onPressed: () => pageManager.play(),
                      );
                    case ButtonState.playing:
                      return IconButton(
                        icon: const Icon(Icons.pause),
                        iconSize: 50.0,
                        color: AppColors.white,
                        onPressed: pageManager.pause,
                      );
                  }
                },
              ),
            ),
          ),
          Center(
            child: IconButton(
                icon: const Icon(
                  Icons.skip_next,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  next(pageManager, context);
                }),
            //  => audioManagerInstance.next()),
          ),
        ],
      ),
    ),
  ]);
}
