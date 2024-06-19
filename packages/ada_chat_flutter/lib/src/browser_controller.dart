import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserController extends ChangeNotifier {
  WebViewController? _controller;
  String _title = '';
  String _host = '';
  bool _isHttps = true;
  bool _backIsAvailable = false;
  bool _forwardIsAvailable = false;

  void init(WebViewController controller) => _controller = controller;

  Future<void> goBack() async => _controller?.goBack();

  Future<void> goForward() async => _controller?.goForward();

  Future<void> reload() async => _controller?.reload();

  String get title => _title;

  void setTitle(String text) {
    _title = text;
    notifyListeners();
  }

  String get host => _host;

  void setHost(String host) {
    _host = host;
    notifyListeners();
  }

  bool get isHttps => _isHttps;

  void setIsHttps(bool isHttps) {
    _isHttps = isHttps;
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
