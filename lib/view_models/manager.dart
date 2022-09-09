import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:sound_flex/view_models/auth_provider.dart';


final getIt = GetIt.instance;

class PageManager extends ChangeNotifier {
  late AudioPlayer _audioPlayer;

  // final _audioHandler = getIt<MyAudioHandler>();
  int? _indexSelected;
  int? get indexSelected => _indexSelected;
  late PageManager _pageManager = PageManager();
  PageManager get pageManager => _pageManager;

PageManager() {
  _init();
}
  void setIndexSelected(int index) {
    _indexSelected = index;
    notifyListeners();
  }

  void setPageManager(PageManager pageManager) {
    _pageManager = pageManager;
    notifyListeners();
  }

 void _init() async {
  _audioPlayer = AudioPlayer();
    // _audioPlayer = AudioPlayer();
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else {
        buttonNotifier.value = ButtonState.playing;
      }
    });

//to listen to changes in the play position
    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
//to listen to changes in the buffer position
    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

//to listen to changes in the duration stream
    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void play() => _audioPlayer.play();
  void stop() => _audioPlayer.stop();
  void pause() => _audioPlayer.pause();

  void seek(Duration position) => _audioPlayer.seek(position);

  void setPlay(
    BuildContext context,
  ) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    await _audioPlayer.setUrl(authProvider.songTempLink!.link!);
    _audioPlayer.play();
    notifyListeners();
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
