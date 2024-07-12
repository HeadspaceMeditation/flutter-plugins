import 'dart:convert';

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

bool isInternalAdaUrl(Uri uri, Uri embedUri, String handle) =>
    isAdaChatLink(uri, embedUri) ||
    isAdaSupportLink(uri, handle) ||
    isBlankPage(uri);

bool isBlankPage(Uri uri) => uri.toString() == 'about:blank';

bool isAdaSupportLink(Uri uri, String handle) =>
    uri.host == '$handle.ada.support';

bool isAdaChatLink(Uri uri, Uri embedUri) => uri == embedUri;

dynamic jsonStrToMap(String message) {
  if (message.isEmpty) {
    return <String, dynamic>{};
  }

  return json.decode(message);
}
