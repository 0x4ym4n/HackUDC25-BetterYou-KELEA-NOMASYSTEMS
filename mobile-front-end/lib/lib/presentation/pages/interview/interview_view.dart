import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../config/theme/app_colors.dart';
import '../../common/character.dart';
import '../../common/sequence_animator.dart';
import 'interview_logic.dart';
import 'interview_state.dart';

class InterviewPage extends StatefulWidget {
  const InterviewPage({Key? key}) : super(key: key);

  @override
  _InterviewPageState createState() => _InterviewPageState();
}

class _InterviewPageState extends State<InterviewPage>
    with TickerProviderStateMixin {
  final logic = Get.put(InterviewLogic());

  @override
  void initState() {
    super.initState();
    try {} catch (e) {}
  }

  @override
  void dispose() {
    Get.delete<InterviewLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: logic.obx(
        (state) => _buildBody(logic, state),
        onLoading: const Center(child: CircularProgressIndicator()),
        onEmpty: const Center(child: Text("No Data")),
        onError: (error) => Center(child: Text(error.toString())),
      ),
    );
  }
}

Widget _buildBody(InterviewLogic logic, InterviewState state) {
  final scrollController = ScrollController();

  return Scaffold(
    backgroundColor: AppColors.lightBlueBackground,
    body: _buildMainContent(logic, state, scrollController),
  );
}

Widget _buildMainContent(InterviewLogic logic, InterviewState state,
    ScrollController scrollController) {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    transitionBuilder: (child, animation) {
      return FadeTransition(opacity: animation, child: child);
    },
    child: () {
      return _buildInterviewContent(logic, state, scrollController);

      return const SizedBox.shrink();
    }(),
  );
}

Widget _buildFeedbackContent() {
  return Center(
    key: const ValueKey('feedback'),
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Character(),
          Text(
            "analyzing_your_feedback".tr,
            style: Get.theme.textTheme.labelMedium!.copyWith(
                fontSize: 22,
                color: AppColors.white,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    ),
  );
}

Widget _buildInterviewContent(InterviewLogic logic, InterviewState state,
    ScrollController scrollController) {
  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  return SingleChildScrollView(
    child: Column(
      key: const ValueKey('interview'),
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: SizedBox(height: Get.height * 0.15, child: Character()),
          ),
        ),
        Container(
          constraints: BoxConstraints(
              minHeight: Get.height * 0.75, maxHeight: Get.height * 0.75),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(50),
            ),
            color: AppColors.darkGreenBackground,
          ),
          child: Obx(() {
            final messages = logic.getLatestSegments();
            WidgetsBinding.instance
                .addPostFrameCallback((_) => scrollToBottom());

            if (messages.isEmpty) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Connecting",
                      style: Get.textTheme.labelLarge!.copyWith(
                          fontSize: 16,
                          color: AppColors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 5),
                    LoadingDots(),
                  ],
                ),
              );
            }

            return ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isAI = message.speakerIdentity.contains("agent");
                final isEnglish =
                    !RegExp(r'[\u0600-\u06FF]').hasMatch(message.text);

                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isAI
                        ? Colors.blue.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      !isAI
                          ? SvgPicture.asset(
                              "assets/svg/user_voice.svg",
                              height: Get.height * 0.035,
                            )
                          : Image.asset(
                              "assets/png/character.png",
                              height: Get.height * 0.025,
                            ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          message.text,
                          style: Get.textTheme.labelMedium!.copyWith(
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w500),
                          textDirection:
                              isEnglish ? TextDirection.ltr : TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    ),
  );
}

class LoadingDots extends StatefulWidget {
  @override
  _LoadingDotsState createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _dotCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _dotCount = IntTween(begin: 1, end: 3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   Get.find<InterviewLogic>().closeInterview();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Text(
          '.' * _dotCount.value,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontSize: 18,
                color: AppColors.white,
              ),
        );
      },
    );
  }
}
