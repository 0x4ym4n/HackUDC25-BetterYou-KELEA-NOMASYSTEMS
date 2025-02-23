import 'dart:io';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../config/core/routes/app_routes.dart';
import '../../../../config/data/remote_datasource.dart';
import '../../../config/theme/app_colors.dart';
import '../../common/character.dart';
import '../../common/custom_navigation_bar.dart';
import '../../common/home_card.dart';
import '../../common/recommendation_card.dart';
import '../../common/streaks_card.dart';
import '../interview/interview_view.dart';
import 'home_logic.dart';
import 'home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<HomePage> {
  @override
  void dispose() {
    Get.delete<HomeModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get.delete<AddModel>();
    final HomeModel model = Get.put(HomeModel());

    return Scaffold(
      backgroundColor: AppColors.darkGreenBackground,
      body: model.obx(
        (state) => _buildBody(model, state),
        onLoading: const Center(child: CircularProgressIndicator()),
        onEmpty: const Center(child: Text("No Data")),
        onError: (error) => Text(error.toString()),
      ),
    );
  }
}

Widget _buildBody(HomeModel model, HomeState state) {
  return Scaffold(
    bottomNavigationBar: Padding(
      padding: EdgeInsets.only(
          bottom:
              Platform.isIOS ? 20 : MediaQuery.of(Get.context!).padding.bottom),
      child: CustomBottomNavBar(
        currentIndex: state.currentBottomNavIndex,
        onTap: (index) {
          model.updateBottomNavIndex(index);
        },
      ),
    ),
    backgroundColor: AppColors.lightBlueBackground,
    body: AnimatedOpacity(
      opacity: state.isPageVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 150),
      child: IndexedStack(
        index: state.currentBottomNavIndex,
        children: List.generate(5, (index) {
          if (index == state.currentBottomNavIndex) {
            switch (index) {
              case 0:
                return _buildWelcomePage(model);
              case 1:
                return InterviewPage();
              case 2:
                return Container();
              case 3:
                return _buildStats(model);
              case 4:
                return _buildProfile(model);
              default:
                return Container();
            }
          } else {
            return Container(); // Empty container for non-visible pages
          }
        }),
      ),
    ),
  );
}

Widget _buildProfile(HomeModel model) {
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Get.height * 0.10),
        Container(
          height: Get.height * 0.82,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.elliptical(200, 100),
            ),
            color: AppColors.darkGreenBackground,
          ),
          child: Column(
            children: [
              SizedBox(height: 50),
              CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.pillsGreen,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.delete_forever, color: Colors.red),
                      title: Text(
                        'Delete All Data',
                        style: TextStyle(color: Colors.white),
                      ),
                      tileColor: AppColors.pillsGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      onTap: () {
                        Get.defaultDialog(
                          title: 'Delete All Data',
                          titleStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          middleText:
                              'Are you sure you want to delete all your data? This action cannot be undone.',
                          middleTextStyle: TextStyle(color: Colors.black87),
                          backgroundColor: Colors.white,
                          radius: 10,
                          textConfirm: 'Delete',
                          textCancel: 'Cancel',
                          confirmTextColor: Colors.white,
                          cancelTextColor: AppColors.pillsGreen,
                          buttonColor: Colors.red,
                          onConfirm: () async {
                            await model.api.wipeAllMainData();
                            Get.back();
                            Get.snackbar(
                              'Success',
                              'All data has been deleted',
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                            model.fetchCounts();
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.white),
                      title: Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                      tileColor: AppColors.pillsGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      onTap: () {
                        Get.defaultDialog(
                          title: 'Logout',
                          titleStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          middleText: 'Are you sure you want to logout?',
                          middleTextStyle: TextStyle(color: Colors.black87),
                          backgroundColor: Colors.white,
                          radius: 10,
                          textConfirm: 'Logout',
                          textCancel: 'Cancel',
                          confirmTextColor: Colors.white,
                          cancelTextColor: AppColors.pillsGreen,
                          buttonColor: Colors.red,
                          onConfirm: () {
// Clear local storage and navigate to login
                            model.localDB.clearAll();
                            Get.back();
                            Get.toNamed(AppRoutes.onboarding);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildWelcomePage(HomeModel model) {
  return SingleChildScrollView(
    child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Center(child: SizedBox(height: 120, width: 200, child: Character())),
          SizedBox(height: 50),
          Container(
            height: Get.height * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.elliptical(200, 100),
              ),
              color: AppColors.darkGreenBackground,
            ),
            child: Column(
              children: [
                SizedBox(height: 200),
                HomeCard(
                  counter:
                      model.localDB.journalCount.toString().padLeft(2, '0'),
                  title: 'Journaling',
                  content: "This week",
                  onPressed: () {
                    Get.toNamed(AppRoutes.journals);
                  },
                ),
                SizedBox(height: 10),
                HomeCard(
                  counter:
                      model.localDB.checkInCount.toString().padLeft(2, '0'),
                  title: 'Check-ins',
                  content: "This week",
                  onPressed: () {
                    Get.toNamed(AppRoutes.checkIn);
                  },
                ),
              ],
            ),
          ),
        ]),
  );
}

Widget _buildStats(HomeModel model) {
  return SingleChildScrollView(
    child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Get.height * 0.10),
          Container(
            height: Get.height * 0.82,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.elliptical(200, 100),
              ),
              color: AppColors.darkGreenBackground,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Your Stats",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                StreaksCard(
                  title: 'Streaks',
                  counter: model.calculateCurrentStreak().toString(),
                  onPressed: () {
                    Get.toNamed(AppRoutes.journals);
                  },
                ),
                Row(
                  children: [
                    RecommendationCard(
                      title: 'Personality',
                      content: model.state.dominantTrait,
                      onPressed: () {
                        Get.toNamed(AppRoutes.journals);
                      },
                    ),
                    RecommendationCard(
                      title: 'Your recommendation',
                      content: "",
                      onPressed: () {
                        Get.toNamed(AppRoutes.journals);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.pillsGreen,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(
                              isInversed: true, // Reverse the x-axis direction
                            ),
                            series: <CartesianSeries>[
                              LineSeries<CheckIn, String>(
                                  enableTooltip: true,
                                  dataSource: model.localDB.checkIns,
                                  xValueMapper: (CheckIn data, _) =>
                                      data.date?.substring(5, 10) ??
                                      '', // Show MM-DD format
                                  yValueMapper: (CheckIn data, _) =>
                                      data.mood.toDouble(),
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                  ))
                            ]),
                      )),
                )
              ],
            ),
          ),
        ]),
  );
}

Widget _buildBody2(HomeModel model, HomeState state) {
  return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            bottom: Platform.isIOS
                ? 20
                : MediaQuery.of(Get.context!).padding.bottom),
        child: CustomBottomNavBar(
          currentIndex: state.currentBottomNavIndex,
          onTap: (index) {
            model.updateBottomNavIndex(index);
          },
        ),
      ),
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

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}
