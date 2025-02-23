import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rating_and_feedback_collector/rating_and_feedback_collector.dart';
import '../../../config/core/routes/app_routes.dart';
import '../pages/home/home_logic.dart';
import 'button.dart';

class SheetAdd extends StatefulWidget {
  final Function(double, List<String>, List<String>) onCheckInSubmit;
  final Function(String, String) onJournalSubmit;

  const SheetAdd({
    super.key,
    required this.onCheckInSubmit,
    required this.onJournalSubmit,
  });

  @override
  _SheetAddState createState() => _SheetAddState();
}

class _SheetAddState extends State<SheetAdd> {
  bool showCheckIn = false;
  bool showJournal = false;
  bool showEmotions = false;
  double selectedRating = 0;
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<String> selectedEmotions = [];
  List<String> selectedReasons = [];

  void updateRating(double rating) {
    setState(() {
      selectedRating = rating;
    });
  }

  Widget buildChipGroup(String title, List<String> options,
      List<String> selectedItems, Function(String) onToggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((item) {
            return FilterChip(
              selected: selectedItems.contains(item),
              label: Text(item),
              onSelected: (bool selected) {
                onToggle(item);
              },
              selectedColor: Colors.green,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color:
                    selectedItems.contains(item) ? Colors.white : Colors.green,
              ),
              backgroundColor: Colors.transparent,
              shape: StadiumBorder(
                side: BorderSide(color: Colors.green),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      type: MaterialType.transparency,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: Get.width,
                constraints: BoxConstraints(
                  minHeight: 300,
                  maxHeight: constraints.maxHeight * 0.85,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(32.0, 32.0, 32.0,
                        MediaQuery.of(context).viewInsets.bottom + 32.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.2),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        key: ValueKey(
                            '${showCheckIn}_${showJournal}_${showEmotions}'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!showCheckIn && !showJournal) ...[
                            RoundedButton(
                              onPressed: () =>
                                  setState(() => showCheckIn = true),
                              text: 'Check in',
                            ),
                            const SizedBox(height: 16),
                            RoundedButton(
                              onPressed: () =>
                                  setState(() => showJournal = true),
                              text: 'New Journal',
                            ),
                          ] else if (showCheckIn && !showEmotions) ...[
                            Text(
                              'Check-in',
                              style: textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'I\'m feeling:',
                              style: textTheme.titleLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: RatingBarEmoji(
                                imageSize: Get.width * 0.15,
                                currentRating: selectedRating,
                                onRatingChanged: updateRating,
                              ),
                            ),
                            const SizedBox(height: 24),
                            RoundedButton(
                              onPressed: () =>
                                  setState(() => showEmotions = true),
                              text: 'Next',
                            ),
                          ] else if (showCheckIn && showEmotions) ...[
                            buildChipGroup(
                              'What emotions best describe this feeling?',
                              [
                                'Happy',
                                'Excited',
                                'Calm',
                                'Peaceful',
                                'Anxious',
                                'Sad'
                              ],
                              selectedEmotions,
                              (emotion) {
                                setState(() {
                                  if (selectedEmotions.contains(emotion)) {
                                    selectedEmotions.remove(emotion);
                                  } else {
                                    selectedEmotions.add(emotion);
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 24),
                            buildChipGroup(
                              'What made you feel this way?',
                              [
                                'Work',
                                'Family',
                                'Friends',
                                'Health',
                                'Weather',
                                'Other'
                              ],
                              selectedReasons,
                              (reason) {
                                setState(() {
                                  if (selectedReasons.contains(reason)) {
                                    selectedReasons.remove(reason);
                                  } else {
                                    selectedReasons.add(reason);
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 24),
                            RoundedButton(
                              onPressed: () async {
                                // Show loading
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );

                                // Process check-in
                                await widget.onCheckInSubmit(selectedRating,
                                    selectedEmotions, selectedReasons);
                                if (mounted) {
                                  Navigator.pop(context); // Close loading
                                  Navigator.pop(context); // Close sheet
                                }
                                if (selectedRating < 3) {
                                  Get.toNamed(AppRoutes.chat);
                                }
                                // Close loading and sheet
                              },
                              text: 'Submit',
                            ),
                          ] else if (showJournal) ...[
                            Text(
                              'New Journal',
                              style: textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: titleController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Title',
                                hintStyle: TextStyle(color: Colors.white70),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white70),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: contentController,
                              style: const TextStyle(color: Colors.white),
                              maxLines: 5,
                              decoration: const InputDecoration(
                                hintText: 'Write your thoughts...',
                                hintStyle: TextStyle(color: Colors.white70),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white70),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            RoundedButton(
                              onPressed: () async {
                                // Show loading
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );

                                // Process journal submission
                                await widget.onJournalSubmit(
                                  titleController.text,
                                  contentController.text,
                                );

                                // Close loading and sheet
                                if (mounted) {
                                  Navigator.pop(context); // Close loading
                                  Navigator.pop(context); // Close sheet
                                }
                              },
                              text: 'Submit',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

void showSheet() {
  final HomeModel homeModel = Get.find<HomeModel>();

  showDialog(
    context: Get.context!,
    barrierColor: Colors.transparent,
    builder: (context) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: SheetAdd(
            onCheckInSubmit: (rating, selectedEmotions, selectedReasons) async {
              // Convert rating to integer (1-5)

              // Get the selected emotions and reasons from the sheet state

              await homeModel.addCheckIn(
                rating.toInt(),
                selectedEmotions,
                selectedReasons,
              );
            },
            onJournalSubmit: (title, content) async {
              await homeModel.addJournalEntry(title, content);
            },
          ),
        ),
      );
    },
  );
}
