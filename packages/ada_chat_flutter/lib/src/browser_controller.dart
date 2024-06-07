import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class BrowserController extends ChangeNotifier {
  InAppWebViewController? _controller;
  String _title = '';
  bool _backIsAvailable = false;
  bool _forwardIsAvailable = false;

  void init(InAppWebViewController controller) => _controller = controller;

  Future<void> goBack() async => _controller?.goBack();

  Future<void> goForward() async => _controller?.goForward();

  String get title => _title;
  void setTitle(String text) {
    _title = text;
    notifyListeners();
  }

  bool get backIsAvailable => _backIsAvailable;
  void setBackIsAvailable(bool isAvailable) {
    _backIsAvailable = isAvailable;
    notifyListeners();
  }

  bool get forwardIsAvailable => _forwardIsAvailable;
  void setForwardIsAvailable(bool isAvailable) {
    _forwardIsAvailable = isAvailable;
    notifyListeners();
  }
}
