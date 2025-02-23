import 'package:better_you/lib/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/button.dart';
import '../../common/character.dart';
import 'onboarding_logic.dart';
import 'onboarding_state.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final bool isPassword;
  final bool isUnderlined;

  const CustomTextField({
    required this.hintText,
    required this.onChanged,
    this.isPassword = false,
    this.isUnderlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: isPassword,
      style: TextStyle(
        color: AppColors.pillsGreen,
        fontWeight: FontWeight.bold,
        fontSize: isUnderlined ? 16 : 16,
      ),
      decoration: isUnderlined
          ? InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: AppColors.pillsGreen.withOpacity(0.7),
                fontWeight: FontWeight.bold,
              ),
              contentPadding: EdgeInsets.only(left: 10),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.pillsGreen, width: 2.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.pillsGreen, width: 2.0),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.pillsGreen, width: 3.0),
              ),
            )
          : InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(),
            ),
    );
  }
}

class GoalCard extends StatelessWidget {
  const GoalCard({
    Key? key,
    required this.title,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: Get.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.pillsGreen,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.secondaryAction,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColors.lightText,
                    ),
                    child: SizedBox(
                      height: 30,
                      width: 25,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '00',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: AppColors.pillsGreen,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.pillsGreen,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onChanged: onChanged,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Entries',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.lightText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  void dispose() {
    Get.delete<OnboardingLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final OnboardingLogic logic = Get.put(OnboardingLogic());

    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: logic.obx(
        (state) => _buildBody(logic, state),
        onLoading: const Center(child: CircularProgressIndicator()),
        onEmpty: const Center(child: Text("No Data")),
        onError: (error) => Text(error.toString()),
      ),
    );
  }
}

Widget _buildBody(OnboardingLogic logic, OnboardingState state) {
  return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: PageView(
          controller: logic.pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildWelcomePage(logic, state),
            _buildNamePage(logic, state),
            _buildEmailPage(logic, state),
            _buildGoalsPage(logic, state),
            _buildNotificationPage(logic, state),
          ],
        ),
      ));
}

Widget _buildNotificationPage(OnboardingLogic logic, OnboardingState state) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 60),
      Character(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Would you like to receive daily reminders?',
          style: TextStyle(
            fontSize: 30,
            height: 1.1,
            color: AppColors.pillsGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Spacer(),
      Center(
          child: RoundedButton(
        onPressed: logic.nextPage,
        text: 'TURN ON NOTIFICATIONS',
      )),
      SizedBox(height: 20),
      if (state.currentPage == 4)
        Center(
          child: GestureDetector(
            onTap: logic.nextPage,
            child: Text(
              'I\'ll manage without them',
              style: TextStyle(
                color: AppColors.secondaryAction,
                fontSize: 20,
              ),
            ),
          ),
        ),
      SizedBox(height: 40),
    ],
  );
}

Widget _buildWelcomePage(OnboardingLogic logic, OnboardingState state) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 60),
      Character(),
      SizedBox(height: 50),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Hey there!\nTake a step into',
          style: TextStyle(
            fontSize: 30,
            height: 1.1,
            color: AppColors.pillsGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'BetterYou',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.w900,
            color: AppColors.pillsGreen,
          ),
        ),
      ),
      Spacer(),
      Center(
          child: RoundedButton(
        onPressed: logic.nextPage,
        text: 'GET STARTED',
      )),
      SizedBox(height: 20),
      if (state.currentPage == 0)
        Center(
          child: Text(
            'Already have an account?',
            style: TextStyle(
              color: AppColors.secondaryAction,
              fontSize: 20,
            ),
          ),
        ),
      SizedBox(height: 40),
    ],
  );
}

Widget _buildNamePage(OnboardingLogic logic, OnboardingState state) {
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 60),
        Character(),
        SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Alright!\nHow should I call you?',
            style: TextStyle(
                fontSize: 30,
                color: AppColors.pillsGreen,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: Get.height * 0.1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomTextField(
            hintText: 'Enter your name',
            onChanged: logic.updateName,
            isUnderlined: true,
          ),
        ),
        SizedBox(height: Get.height * 0.15),
        Center(
            child: RoundedButton(
          onPressed: logic.nextPage,
          text: 'NEXT',
        )),
        SizedBox(height: 40),
      ],
    ),
  );
}

Widget _buildEmailPage(OnboardingLogic logic, OnboardingState state) {
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 60),
        Character(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Cool!\nLet\'s create you an account',
            style: TextStyle(
                fontSize: 30,
                color: AppColors.pillsGreen,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: Get.height * 0.05),
        CustomTextField(
          hintText: 'Enter your email',
          onChanged: logic.updateEmail,
          isUnderlined: true,
        ),
        SizedBox(height: 20),
        CustomTextField(
          hintText: 'Enter your password',
          onChanged: logic.updatePassword,
          isUnderlined: true,
          isPassword: true,
        ),
        SizedBox(height: Get.height * 0.1),
        Center(
            child: RoundedButton(
          onPressed: logic.nextPage,
          text: 'NEXT',
        )),
        SizedBox(height: 40),
      ],
    ),
  );
}

Widget _buildGoalsPage(OnboardingLogic logic, OnboardingState state) {
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 60),
        Character(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Great, ${state.name}!\nLet\'s set up your goals',
            style: TextStyle(
                fontSize: 30,
                color: AppColors.pillsGreen,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 40),
        GoalCard(
          title: 'Journaling',
          onChanged: (value) {
            // Handle the change
          },
        ),
        SizedBox(height: 5),
        GoalCard(
          title: 'Check-ins',
          onChanged: (value) {
            // Handle the change
          },
        ),
        SizedBox(height: 40),
        Center(
            child: RoundedButton(
          onPressed: logic.nextPage,
          text: 'NEXT',
        )),
        SizedBox(height: 40),
      ],
    ),
  );
}
