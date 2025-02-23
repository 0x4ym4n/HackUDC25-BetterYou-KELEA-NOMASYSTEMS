import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../config/core/routes/app_routes.dart';
import '../home/home_view.dart';
import 'onboarding_state.dart';
import '/config/core/services/base_controller.dart';

class OnboardingLogic extends BaseGetxController with StateMixin<dynamic> {
  final OnboardingState state = OnboardingState();
  final pageController = PageController();

  void nextPage() {
    if (state.currentPage < 4) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      state.currentPage++;
      change(state, status: RxStatus.success());
    } else {
      localDB.localDataStore.put('name', state.name);
      localDB.localDataStore.put('email', state.email);
      localDB.localDataStore.put('password', state.password.trim());
      Get.to(() => const HomePage());
    }
  }

  void updateName(String value) {
    state.name = value;
    change(state, status: RxStatus.success());
  }

  void updateEmail(String value) {
    state.email = value;
    change(state, status: RxStatus.success());
  }

  void updatePassword(String value) {
    state.password = value;
    change(state, status: RxStatus.success());
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    if (localDB.localDataStore.get('name') != null) {
      Get.back();
      Get.to(() => const HomePage());
    } else {
      change(state, status: RxStatus.success());
    }
    super.onReady();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
