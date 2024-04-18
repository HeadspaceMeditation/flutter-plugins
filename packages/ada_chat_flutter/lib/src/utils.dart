import 'package:flutter/foundation.dart';

String get getOsName {
  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'ANDROID';
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    return 'IOS';
  } else {
    return 'N/A';
  }
}
