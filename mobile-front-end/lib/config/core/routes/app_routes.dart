import 'package:better_you/lib/presentation/pages/check-in/check_in_view.dart';
import 'package:better_you/lib/presentation/pages/onboarding/onboarding_view.dart'; // Fixed import path
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:better_you/lib/presentation/pages/home/home_view.dart';

import 'package:better_you/lib/presentation/pages/interview/interview_view.dart';
import 'package:better_you/lib/presentation/pages/journals/journal_view.dart';

class AppRoutes {
  static const String onboarding = '/';
  static const String home = '/home';
  static const String journals = '/journals';
  static const String checkIn = '/check-in';
  static const String chat = '/chat';

  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return CustomPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (_) => const OnboardingPage());

      case home:
        return CustomPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (_) => const HomePage());

      case journals:
        return CustomPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (_) => const JournalPage());
      case chat:
        return CustomPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (_) => const InterviewPage());

      case checkIn:
        return CustomPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (_) => const CheckInPage());
      default:
        return CustomPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text("no_route_defined_for_settings_name_".tr +
                          settings.name!)),
                ));
    }
  }
}

class CustomPageRoute extends MaterialPageRoute {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 500);

  CustomPageRoute({settings, builder})
      : super(builder: builder, settings: settings);
}
