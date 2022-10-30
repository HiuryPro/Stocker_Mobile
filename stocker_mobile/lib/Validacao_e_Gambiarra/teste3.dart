import 'package:flutter/material.dart';

class FrogColor extends InheritedWidget {
  const FrogColor(
      {super.key,
      required this.color,
      required super.child,
      required this.trocaColor,
      required this.troca,
      required this.count});

  final Color color;
  final Function() trocaColor;
  final bool troca;
  final int count;

  static FrogColor of(BuildContext context) {
    final FrogColor? result =
        context.dependOnInheritedWidgetOfExactType<FrogColor>();
    assert(result != null, 'No FrogColor found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(FrogColor old) =>
      color != old.color || count != old.count;
}
