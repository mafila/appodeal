import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AppodealBanner extends StatefulWidget {
  @override
  _AppodealBannerState createState() => _AppodealBannerState();
}

class _AppodealBannerState extends State<AppodealBanner> {
  bool isVisible = true;
  final key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: key,
      onVisibilityChanged: (info) {
        print(info.visibleFraction);
        if (mounted) setState(() => isVisible = info.visibleFraction == 1);
      },
      child: Container(
        width: 320,
        height: 50,
        child: isVisible ? _PlatformView() : Container(width: 1, height: 1)
      ),
    );
  }
}

class _PlatformView extends StatelessWidget {
  static const MethodChannel _channel = const MethodChannel('appodeal_flutter');

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ?
      UiKitView(
        viewType: 'plugins.io.vinicius.appodeal/banner',
        creationParams: {},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (_) => _channel.invokeMethod('show', { 'adType': 1 }),
      ) :
      AndroidView(
        viewType: 'plugins.io.vinicius.appodeal/banner',
        creationParams: {},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (_) => _channel.invokeMethod('show', { 'adType': 1 }),
      );
  }
}