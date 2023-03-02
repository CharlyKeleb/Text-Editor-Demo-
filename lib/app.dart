import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_editor_flutter/views/home/home.dart';
import 'package:text_editor_flutter/views/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ThemeConfig.appName,
      theme: themeData(ThemeConfig.lightTheme),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}


// Apply font to our app's theme
ThemeData themeData(ThemeData theme) {
  return theme.copyWith(
    textTheme: GoogleFonts.poppinsTextTheme(
      theme.textTheme,
    ),
  );
}
