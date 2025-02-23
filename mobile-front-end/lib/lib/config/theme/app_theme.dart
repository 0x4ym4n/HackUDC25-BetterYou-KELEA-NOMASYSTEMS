import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData setTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.poppins().fontFamily,
    canvasColor: Colors.transparent,
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    }),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.white,
      primary: Colors.green,
    ),
  );
}


