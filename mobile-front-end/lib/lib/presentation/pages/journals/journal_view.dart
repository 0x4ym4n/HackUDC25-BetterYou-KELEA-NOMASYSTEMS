import 'dart:io';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/core/routes/app_routes.dart';
import '../../../config/theme/app_colors.dart';
import '../../common/character.dart';
import '../../common/custom_navigation_bar.dart';
import '../../common/home_card.dart';
import '../../common/journal_card.dart';
import 'journal_logic.dart';
import 'journal_state.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  @override
  void dispose() {
    Get.delete<JournalModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get.delete<AddModel>();
    final JournalModel model = Get.put(JournalModel());

    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: model.obx(
        (state) => _buildBody(model, state),
        onLoading: const Center(child: CircularProgressIndicator()),
        onEmpty: const Center(child: Text("No Journals Yet")),
        onError: (error) => Text(error.toString()),
      ),
    );
  }
}

Widget _buildBody(JournalModel model, JournalState state) {
  return PageView(
    controller: model.pageController,
    physics: const NeverScrollableScrollPhysics(),
    children: [
      _buildWelcomePage(model),
    ],
  );
}

Widget _buildWelcomePage(JournalModel model) {
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
                    "Your Journals",
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
                  final entry = model.state.entries[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: JournalCard(
                      counter: "",
                      title: entry.title,
                      content: entry.text,
                      onPressed: () {
                        Get.toNamed(AppRoutes.journals, arguments: entry);
                      },
                    ),
                  );
                },
                childCount: model.state.entries.length,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildBody2(JournalModel model, JournalState state) {
  return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: Column(
        children: [
          Character(),
          SizedBox(height: 20),
          IgnorePointer(
            child: CalendarTimeline(
              initialDate: DateTime(2020, 4, 1),
              firstDate: DateTime(2019, 1, 15),
              lastDate: DateTime(2020, 11, 20),
              onDateSelected: (date) => print(date),
              leftMargin: 20,
              monthColor: Colors.blueGrey,
              dayColor: Colors.teal[200],
              activeDayColor: Colors.white,
              activeBackgroundDayColor: Colors.redAccent[100],
              dotColor: Color(0xFF333A47),
              selectableDayPredicate: (date) => date.day != 23,
              locale: 'en_ISO',
              shrink: false,
            ),
          ),
        ],
      ));
}
