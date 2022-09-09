import 'package:sound_flex/view_models/manager.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // services
  // getIt.registerSingleton<AudioHandler>(await initAudioService());

  // page state
  getIt.registerLazySingleton<PageManager>(() => PageManager());
  // getIt.registerLazySingleton<MyAudioHandler>(() => MyAudioHandler());
}