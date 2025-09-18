import 'package:bloc_explore/factory_method_pattern.dart';
import 'package:bloc_explore/platform_indicator.dart';
import 'package:flutter/material.dart';

abstract class AbstractFactory {
  Widget buildButton(BuildContext context, String text, VoidCallback onPressed);
  Widget buildIndicator(BuildContext context);
}

class AbstractFactoryImpl implements AbstractFactory {
  @override
  Widget buildButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return PlatformButton(Theme.of(context).platform)
        .build(Text(text), onPressed);
  }

  @override
  Widget buildIndicator(BuildContext context) {
    return PlatformIndicator(Theme.of(context).platform).build();
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
        }),
        AbstractFactoryImpl().buildButton(context, 'child', () {}),
        AbstractFactoryImpl().buildIndicator(
          context,
        ),
      ],
    );
  }
}
