import 'package:get/get.dart';

import 'add_state.dart';
import '/config/core/services/base_controller.dart';

class AddModel extends BaseGetxController with StateMixin<dynamic> {
  @override
  final AddState state = AddState();

  @override
  void onReady() {
    change(state, status: RxStatus.success());
    super.onReady();
  }

}
