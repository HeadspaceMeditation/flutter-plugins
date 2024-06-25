import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserController extends ChangeNotifier {
  WebViewController? _controller;
  var _title = '';
  var _host = '';
  var _isHttps = true;
  var _backIsAvailable = false;
  var _forwardIsAvailable = false;
  var _progress = 0;

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

  int get progress => _progress;

  void setProgress(int progress) {
    _progress = progress;
    notifyListeners();
  }

  @override
  String toString() {
    return 'BrowserController{title: $_title, host: $_host, '
        'isHttps: $_isHttps, backIsAvailable: $_backIsAvailable, '
        'forwardIsAvailable: $_forwardIsAvailable, progress: $_progress}';
  }
}
