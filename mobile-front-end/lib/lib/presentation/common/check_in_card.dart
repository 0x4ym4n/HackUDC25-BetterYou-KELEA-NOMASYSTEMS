import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config/theme/app_colors.dart';

class JournalCard extends StatefulWidget {
  const JournalCard({
    super.key,
    required this.title,
    required this.onPressed,
    required this.counter,
    required this.content,
  });

  final String title;
  final void Function() onPressed;
  final String counter;
  final String content;

  @override
  State<JournalCard> createState() => _JournalCardState();
}

class _JournalCardState extends State<JournalCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpand,
      child: Center(
        child: Container(
          width: Get.width * 0.9,
          constraints: BoxConstraints(
            minHeight: 150,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppColors.pillsGreen,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (widget.counter.isNotEmpty)
                          Text(
                            widget.counter,
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: SizedBox(
                        width: Get.width * 0.8,
                        child: AnimatedCrossFade(
                          firstChild: Text(
                            widget.content,
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.secondaryAction,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          secondChild: Text(
                            widget.content,
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.secondaryAction,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          crossFadeState: _isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: Icon(
                  _isExpanded ? Icons.expand_less : Icons.more_horiz,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckInCard extends StatelessWidget {
  const CheckInCard({
    super.key,
    required this.mood,
    required this.feelings,
    required this.events,
    required this.date,
    required this.onPressed,
  });

  final int mood;
  final List<String> feelings;
  final List<String> events;
  final String? date;
  final void Function() onPressed;

  String getMoodEmoji() {
    switch (mood) {
      case 1:
        return '😢';
      case 2:
        return '😕';
      case 3:
        return '😐';
      case 4:
        return '🙂';
      case 5:
        return '😄';
      default:
        return '😐';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Center(
        child: Container(
          width: Get.width * 0.9,
          constraints: BoxConstraints(
            minHeight: 150,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppColors.pillsGreen,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        getMoodEmoji(),
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                    if (date != null)
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 8),
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                DateFormat('MMM d')
                                    .format(DateTime.parse(date!)),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...feelings.map((feeling) => Chip(
                          label: Text(
                            feeling,
                            style: TextStyle(
                              color: AppColors.pillsGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: Colors.white.withOpacity(0.9),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 0),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...events.map((event) => Chip(
                          label: Text(
                            event,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor:
                              AppColors.secondaryAction.withOpacity(0.9),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
