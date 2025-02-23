import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_logic.dart';
import 'add_state.dart';

class aAddPage extends StatefulWidget {
  const aAddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<aAddPage> {
  @override
  void dispose() {
    Get.delete<AddModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get.delete<AddModel>();
    final AddModel model = Get.put(AddModel());

    return Scaffold(
      body: model.obx(
        (state) => _buildBody(model, state),
        onLoading: const Center(child: CircularProgressIndicator()),
        onEmpty: const Center(child: Text("No Data")),
        onError: (error) => Text(error.toString()),
      ),
    );
  }
}

Widget _buildBody(AddModel model, AddState state) {
  return Scaffold(body: Container());
}
