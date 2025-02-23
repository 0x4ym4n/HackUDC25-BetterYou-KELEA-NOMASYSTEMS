import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/core/services/base_controller.dart';
import 'journal_state.dart';

class JournalModel extends BaseGetxController with StateMixin<dynamic> {
  @override
  final JournalState state = JournalState();
  final pageController = PageController();

  @override
  void onReady() {
    fetchJournalEntries();
    super.onReady();

    // Future.delayed(const Duration(seconds: 1), () {
    //   Get.toNamed(AppRoutes.chat);
    // });
    //
  }

  Future<void> fetchJournalEntries() async {
    try {
      change(state, status: RxStatus.loading());

      // Replace with your actual API call
      final response = await api.getJournalEntries();

      state.entries = response;
      change(state, status: RxStatus.success());
    } catch (error) {
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  void updateBottomNavIndex(int index) async {
    state.currentBottomNavIndex = index;
    update();
  }
}
