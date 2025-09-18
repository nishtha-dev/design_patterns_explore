import 'package:flutter/material.dart';

abstract class Shape {
  Shape(this.color);

  Shape.clone(Shape source) : color = source.color;

  Color color;

  Shape clone();
  void randomiseProperties();
  Widget render();
}

class Circle extends Shape {
  Circle(this.radius, super.color);

  Circle.initial([super.color = Colors.black]) : radius = 50;

  Circle.clone(Circle super.source)
      : radius = source.radius,
        super.clone();
  double radius;

  @override
  Circle clone() => Circle.clone(this);

  @override
  void randomiseProperties() {
    color = const Color.fromRGBO(
      255,
      (255),
      (255),
      1.0,
    );
    // radius = random.integer(50, min: 25).toDouble();
    radius = 50;
  }

  @override
  Widget render() {
    return SizedBox(
      height: 120.0,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: 2 * radius,
          width: 2 * radius,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.star,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
