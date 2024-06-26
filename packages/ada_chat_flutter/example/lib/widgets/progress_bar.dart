import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.progress,
  });

  final int progress;

  @override
  Widget build(BuildContext context) => AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        top: _isLoading ? 0 : -5,
        left: 0,
        right: 0,
        child: LinearProgressIndicator(
          value: progress / 100,
          minHeight: 5,
        ),
      );

  bool get _isLoading => progress > 0 && progress < 100;
}
