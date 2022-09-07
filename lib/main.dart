import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:sound_flex/screens/home_screen.dart';
import 'package:sound_flex/theme/theme_provider.dart';
import 'package:sound_flex/view_models/app_provider.dart';
import 'package:sound_flex/view_models/auth_provider.dart';
import 'components/scroll_behaviour.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..maxConnectionsPerHost = 5;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
        
      ],
      child:  const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (BuildContext? context, AppProvider? appProvider, Widget? child) {
        return GetMaterialApp(
            key: appProvider!.key,
            debugShowCheckedModeBanner: false,
            navigatorKey: appProvider.navigatorKey,
            title: 'Sound Flex',
            theme: MyThemes.lightTheme,
            // darkTheme: themeData(ThemeConfig.darkTheme),
            builder: (context, child) {
              return ScrollConfiguration(
                  behavior: MyScrollBehaviour(), child: child!);
            },
            home: const HomeScreen());
      },
    );
  }
}