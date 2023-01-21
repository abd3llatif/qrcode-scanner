import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ProgressProvider extends InheritedWidget {
  final ProgressBloc? dialog;

  ProgressProvider({
    Key? key,
    Widget? child,
    this.dialog,
  }) : super(key: key, child: child!);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static ProgressProvider of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<ProgressProvider>())!;
}

class ProgressBloc {
  late ReplaySubject<bool> _showProgressControllers;
  late Stream<bool> _showProgress;

  ProgressBloc() {
    _showProgressControllers = ReplaySubject<bool>();
    _showProgress = _showProgressControllers.stream;
  }

  void showProgress() {
    _showProgressControllers.add(true);
  }

  void hideProgress() {
    _showProgressControllers.add(false);
  }

  Stream<bool> get show => _showProgress;
}
