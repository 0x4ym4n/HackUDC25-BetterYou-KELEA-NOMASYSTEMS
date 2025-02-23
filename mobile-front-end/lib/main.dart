import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'config/core/routes/app_routes.dart';
import 'config/core/services/locator.dart';
import 'config/data/local_datasource.dart';
import 'lib/config/theme/app_theme.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  await locator<LocalDataSource>().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final scale = mediaQuery.textScaleFactor.clamp(0.8, 0.95);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.onboarding,
      onGenerateRoute: AppRoutes.onGenerateRoutes,
      theme: setTheme(),
    );
  }
}
