import 'package:flutter/material.dart';
import 'package:qrcodescanner/bloc/apps_bloc.dart';
import 'package:qrcodescanner/bloc/offers_bloc.dart';
import 'package:qrcodescanner/bloc/profile_bloc.dart';
import 'package:qrcodescanner/bloc/scanner_bloc.dart';
import 'package:qrcodescanner/bloc/settings_bloc.dart';

class StoreBlocProvider extends InheritedWidget {
  StoreBlocProvider({Key? key, Widget? child, this.store})
      : super(key: key, child: child!);
  final Store? store;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static StoreBlocProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<StoreBlocProvider>()!);
  }
}

class Store {
  ProfileBloc profileBloc;
  ScannerBloc scannerBloc;
  AppsBloc appsBloc;
  SettingsBloc settingsBloc;
  OffersBloc offersBloc;

  Store()
      : profileBloc = ProfileBloc(),
       scannerBloc = ScannerBloc(),
       appsBloc = AppsBloc(),
       settingsBloc = SettingsBloc(),
       offersBloc = OffersBloc();
}
