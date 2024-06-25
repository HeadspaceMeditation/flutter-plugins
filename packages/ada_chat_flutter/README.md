# ada_chat_flutter Package

This package provides a widget for integrating Ada chat into your Flutter application. 
It uses the `webview_flutter` package to display the chat interface. The same package is used to 
show internal browser if user taps on link in the chat.

## Features

- Customizable chat settings.
- Customizable in app web browser look and controls.
- Various events callbacks.

## Usage

Check the example folder.

## AdaWebView parameters

### embedUri parameter

File with following content should be placed somewhere on your web server. 

```html
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <script type="text/javascript">
        window.adaSettings = {
            parentElement: "content_frame",
            lazy: true
        };
    </script>

    <script defer id="__ada" src="https://static.ada.support/embed2.js"></script>
</head>

<body style="position: absolute; bottom: 0px; top: 0px; left: 0px; right: 0px; margin: 0; padding: 0;">
<div id="content_frame" style="height: 100%; width: 100%"></div>
</body>

</html>
```

Link to that html file must be passed as `embedUri` parameter to `AdaWebView` widget.

Don't forget to add yor domain to the allow list on Ada dashboard.

### handle parameter

Another required parameter is handle. This is your bot handle from Ada dashboard.

