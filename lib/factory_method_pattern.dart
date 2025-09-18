import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Candidate {
  void work();

  factory Candidate(UserType userType) {
    switch (userType) {
      case UserType.programmer:
        return Programmer();
      case UserType.hr:
        return HR();

      default:
        return Programmer();
    }
  }
}

enum UserType { programmer, hr }

class Programmer implements Candidate {
  @override
  void work() {
    print("codeing");
  }
}

class HR implements Candidate {
  @override
  void work() {
    print("recruiting");
  }
}

void main() {
  Candidate candidate = Candidate(UserType.programmer);
  candidate.work();
}

// flutter example

abstract class PlatformButton {
  Widget build(Widget child, VoidCallback onPressed);

  factory PlatformButton(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
        return AndroidButton();
      case TargetPlatform.iOS:
        return IosButton();
      default:
        return AndroidButton();
    }
  }
}

class AndroidButton implements PlatformButton {
  @override
  Widget build(Widget child, VoidCallback onPressed) {
    return ElevatedButton(onPressed: onPressed, child: child);
  }
}

class IosButton implements PlatformButton {
  @override
  Widget build(Widget child, VoidCallback onPressed) {
    return CupertinoButton.filled(onPressed: onPressed, child: child);
  }
}

class MyPlatformButtonWidget extends StatelessWidget {
  const MyPlatformButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlatformButton(Theme.of(context).platform).build(const Text('click'),
            () {
          print("hello");
        })
      ],
    );
  }
}
