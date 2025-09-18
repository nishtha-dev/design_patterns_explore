import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class PlatformIndicator {
  Widget build();

  Color color();

  factory PlatformIndicator(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
        return AndroidIndicator();
      case TargetPlatform.iOS:
        return IosIndicator();
      default:
        return AndroidIndicator();
    }
  }
}

class AndroidIndicator implements PlatformIndicator {
  @override
  Widget build() {
    return CircularProgressIndicator(
      color: color(),
    );
  }

  @override
  Color color() => Colors.blue;
}

class IosIndicator implements PlatformIndicator {
  @override
  Widget build() {
    return CupertinoActivityIndicator(
      color: color(),
    );
  }

  @override
  Color color() => Colors.red;
}
