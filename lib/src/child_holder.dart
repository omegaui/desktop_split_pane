import 'package:flutter/material.dart';

class ChildHolder extends StatelessWidget {
  ChildHolder({super.key, required this.child});

  final Widget child;
  late Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: child,
    );
  }
}
