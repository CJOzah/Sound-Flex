import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:sound_flex/utils/toasts.dart';
import 'package:sound_flex/view_models/auth_provider.dart';

import '../AppUrl/app_url.dart';

final getIt = GetIt.instance;

// Future<AudioHandler> initAudioService() async {
//   return await AudioService.init(
//     builder: () => PageManager(),
//     // ignore: prefer_const_constructors
//     config: AudioServiceConfig(
//       androidNotificationChannelId: 'com.example.sound_flex.channel.audio',
//       androidNotificationChannelName: 'Sound Flex',
//       androidNotificationOngoing: true,
//       androidStopForegroundOnPause: true,
//     ),
//   );
// }

class PageManager extends ChangeNotifier {
  // late AudioPlayer _audioPlayer;
  final _audioHandler = getIt<AudioHandler>();

  // final _audioHandler = getIt<MyAudioHandler>();
  int? _indexSelected;
  int? get indexSelected => _indexSelected;
  late PageManager _pageManager = PageManager();
  PageManager get pageManager => _pageManager;

  void setIndexSelected(int index) {
    _indexSelected = index;
    notifyListeners();
  }

  void setPageManager(PageManager pageManager) {
    _pageManager = pageManager;
    notifyListeners();
  }

  void init() async {
    // _audioPlayer = AudioPlayer();
    _audioHandler.playbackState.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        // completed
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });

//to listen to changes in the play position
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

//to listen to changes in the buffer position
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });

//to listen to changes in the duration stream
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void play() => _audioHandler.play();
  void stop() => _audioHandler.stop();
  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void setPlay(BuildContext context) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    final mediaItem = MediaItem(
      id: '',
      album: '',
      title: authProvider.songTempLink!.metadata!.name!,
      extras: {'url': authProvider.songTempLink!.link!},
    );

    _audioHandler.addQueueItem(mediaItem);
    // await _audioHandler.setUrl(authProvider.songTempLink!.link!);
    _audioHandler.play();
    notifyListeners();
  }


  Future<Null> Function() setSongLink(BuildContext context, String path) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    // ignore: prefer_function_declarations_over_variables
    return () async {
      final Map<String, dynamic> getTempLink = {"path": path};
      final Future<Map<String, dynamic>> respose =
          authProvider.postRequest(getTempLink, AppUrl.tempLink);
      respose.then((response) async {
        if (response['status'] == null) {
          ToastService().showError(context, 'Failed', response['message']);
        }
        if (response['status'] == true) {
          //  _pageManager = PageManager(context);
          setPlay(context);
          ToastService().showSuccess(context, 'Success', response['message']);
        } else {
          ToastService().showError(context, 'Failed', response['message']);
        }
      });
    };
  }

  Future<void> previousSong(PageManager pageManager, BuildContext context) async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    pageManager.stop();
    if (pageManager.indexSelected! == 0) {
      setSongLink(context, authProvider.songList!.entries!.last.pathLower!);
      pageManager.setIndexSelected(authProvider.songList!.entries!.length - 1);
    } else {
      setSongLink(
          context,
          authProvider
              .songList!.entries![pageManager.indexSelected! - 1].pathLower!);
      pageManager.setIndexSelected(pageManager.indexSelected! - 1);
    }
    _audioHandler.skipToPrevious();
  }

  Future<void> nextSong(PageManager pageManager, BuildContext context) async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    pageManager.stop();
    if (authProvider.songList!.entries!.length - 1 ==
        pageManager.indexSelected) {
      setSongLink(context, authProvider.songList!.entries![0].pathLower!);
      pageManager.setIndexSelected(0);
    } else {
      setSongLink(
          context,
          authProvider
              .songList!.entries![pageManager.indexSelected! + 1].pathLower!);
      pageManager.setIndexSelected(pageManager.indexSelected! + 1);
    }
    _audioHandler.skipToNext();
  }

  // void repeat() {
  //   repeatButtonNotifier.nextState();
  //   final repeatMode = repeatButtonNotifier.value;
  //   switch (repeatMode) {
  //     case RepeatState.off:
  //       _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
  //       break;
  //     case RepeatState.repeatSong:
  //       _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
  //       break;
  //     case RepeatState.repeatPlaylist:
  //       _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
  //       break;
  //   }
  // }

  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { paused, playing, loading }
