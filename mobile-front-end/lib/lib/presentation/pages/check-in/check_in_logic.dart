import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/core/services/base_controller.dart';
import 'check_in_state.dart';

class CheckInModel extends BaseGetxController with StateMixin<dynamic> {
  @override
  final CheckInState state = CheckInState();
  final pageController = PageController();

  @override
  void onReady() {
    fetchCheckIns();
    super.onReady();
  }

  Future<void> fetchCheckIns() async {
    try {
      change(state, status: RxStatus.loading());

      final response = await api.getCheckIns();

      state.checkIns = response;
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
