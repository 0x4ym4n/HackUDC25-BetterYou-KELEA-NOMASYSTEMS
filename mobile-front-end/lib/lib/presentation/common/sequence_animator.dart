import 'package:flutter/material.dart';

import 'fade_transform_animation.dart';

class SequenceAnimator extends StatelessWidget {
  const SequenceAnimator(
      {Key? key,
      required this.child,
      required this.animationController,
      required this.count,
      required this.order})
      : super(key: key);
  final Widget child;
  final AnimationController animationController;
  final int order;
  final int count;

  @override
  Widget build(BuildContext context) {
    return FadeTransformAnimation(
        animationController: animationController,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve: Interval((1 / count) * order, 1.0,
                curve: Curves.fastOutSlowIn))),
        child: child);
  }
}
