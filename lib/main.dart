import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viral_app/provider/theme_manager.dart';
import 'package:viral_app/provider/youtube_data_provider.dart';
import 'package:viral_app/screens/splash_screen.dart';

import 'colors/theme_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => YoutubeDataProvider()),
      ],
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, _) {
          // log("theme ${themeManager.isDarkMode}");
          return MaterialApp(
            themeMode:
                themeManager.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: lightTheme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return child!;
            },
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
