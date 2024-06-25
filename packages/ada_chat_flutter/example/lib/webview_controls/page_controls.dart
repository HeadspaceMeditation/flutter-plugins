import 'dart:ui';

import 'package:ada_chat_flutter/ada_chat_flutter.dart';
import 'package:flutter/material.dart';

class PageControls extends StatelessWidget {
  const PageControls({
    super.key,
    required this.controller,
  });

  final BrowserController controller;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: controller,
        builder: (context, _) => PageControlsInner(controller: controller),
      );
}

class PageControlsInner extends StatelessWidget {
  const PageControlsInner({
    super.key,
    required this.controller,
  });

  final BrowserController controller;

  @override
  Widget build(BuildContext context) => ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Row(
            children: [
              BackArrowButton(controller: controller),
              ForwardArrowButton(controller: controller),
              RefreshButton(controller: controller),
              Expanded(
                child: PageDescription(controller: controller),
              ),
              CloseButton(),
            ],
          ),
        ),
      );
}

class PageDescription extends StatelessWidget {
  const PageDescription({
    super.key,
    required this.controller,
  });

  final BrowserController controller;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            controller.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Row(
            children: [
              Icon(
                controller.isHttps ? Icons.lock : Icons.lock_open,
                size: 10,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  controller.host,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      );
}

class CloseButton extends StatelessWidget {
  const CloseButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.close),
        onPressed: Navigator.of(context).pop,
      );
}

class RefreshButton extends StatelessWidget {
  const RefreshButton({
    super.key,
    required this.controller,
  });

  final BrowserController controller;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: controller.reload,
      );
}

class ForwardArrowButton extends StatelessWidget {
  const ForwardArrowButton({
    super.key,
    required this.controller,
  });

  final BrowserController controller;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_forward_ios),
        onPressed: controller.forwardIsAvailable ? controller.goForward : null,
      );
}

class BackArrowButton extends StatelessWidget {
  const BackArrowButton({
    super.key,
    required this.controller,
  });

  final BrowserController controller;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: controller.backIsAvailable ? controller.goBack : null,
      );
}
