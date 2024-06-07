import 'dart:ui';

import 'package:ada_chat_flutter/ada_chat_flutter.dart';
import 'package:flutter/material.dart';

class PageControls extends StatefulWidget {
  const PageControls({
    super.key,
    required this.controller,
  });

  final BrowserController controller;

  @override
  State<PageControls> createState() => _PageControlsState();
}

class _PageControlsState extends State<PageControls> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: widget.controller.backIsAvailable
                    ? widget.controller.goBack
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: widget.controller.forwardIsAvailable
                    ? widget.controller.goForward
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: widget.controller.reload,
              ),
              Expanded(
                child: Text(
                  widget.controller.title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: Navigator.of(context).pop,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
