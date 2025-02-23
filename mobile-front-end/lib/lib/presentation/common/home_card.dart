import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/theme/app_colors.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Center(
        child: Container(
          height: 110,
          width: Get.width * 0.91,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppColors.pillsGreen,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          if (counter.isNotEmpty)
                            Text(
                              counter,
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          SizedBox(width: 5),
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        height: 50,
                        width: Get.width * 0.65,
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          content,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.secondaryAction,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Column(
                children: [
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.arrow_right_alt_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
