import 'package:audio_service/audio_service.dart';
import 'package:sound_flex/view_models/manager.dart';
import 'audio_handler.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // services
  getIt.registerSingleton<AudioHandler>(await initAudioService());

  // page state
  getIt.registerLazySingleton<PageManager>(() => PageManager());
  // getIt.registerLazySingleton<MyAudioHandler>(() => MyAudioHandler());
}