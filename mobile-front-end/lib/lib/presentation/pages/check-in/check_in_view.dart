import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/theme/app_colors.dart';
import '../../common/check_in_card.dart';
import 'check_in_logic.dart';
import 'check_in_state.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  @override
  void dispose() {
    Get.delete<CheckInModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CheckInModel model = Get.put(CheckInModel());

    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: model.obx(
        (state) => _buildBody(model, state),
        onLoading: const Center(child: CircularProgressIndicator()),
        onEmpty: const Center(child: Text("No Check-ins Yet")),
        onError: (error) => Text(error.toString()),
      ),
    );
  }
}

Widget _buildBody(CheckInModel model, CheckInState state) {
  return Stack(
    children: [
      // Background container with curve
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: 250, // Adjust height as needed
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.darkGreenBackground,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(1000, 100),
            ),
          ),
        ),
      ),

      // Scrollable content
      CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Your Check-ins",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final checkIn = model.state.checkIns[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CheckInCard(
                      mood: checkIn.mood,
                      feelings: checkIn.feelings,
                      events: checkIn.events,
                      date: checkIn.date,
                      onPressed: () {
                        // Navigation logic
                      },
                    ),
                  );
                },
                childCount: model.state.checkIns.length,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
