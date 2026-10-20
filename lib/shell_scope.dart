import 'package:flutter/material.dart';

class ShellScope extends InheritedWidget {
  const ShellScope({super.key, required this.index, required this.goTo, required super.child});

  final int index;
  final void Function(int index) goTo;

  static ShellScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ShellScope>();
    assert(scope != null, 'ShellScope is missing');
    return scope!;
  }

  @override
  bool updateShouldNotify(ShellScope oldWidget) => index != oldWidget.index;
}
