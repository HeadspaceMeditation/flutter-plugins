import 'dart:developer';

import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.progress,
  });

  final int progress;

  @override
  Widget build(BuildContext context) {
    log('@@@ progress=$progress');

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      top: _isNotLoading ? -5 : 0,
      left: 0,
      right: 0,
      child: LinearProgressIndicator(
        value: progress / 100,
        minHeight: 5,
      ),
    );
  }

  bool get _isNotLoading => progress == 0 || progress == 100;
}
