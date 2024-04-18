import 'dart:io';

String get getOsName {
  if (Platform.isAndroid) {
    return 'ANDROID';
  } else if (Platform.isIOS) {
    return 'IOS';
  } else {
    return 'N/A';
  }
}
