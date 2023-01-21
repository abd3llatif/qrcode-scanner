import 'package:flutter/material.dart';
import 'package:qrcodescanner/bloc/auth_bloc.dart';

class AuthBlocProvider extends InheritedWidget{
  final bloc;

  AuthBlocProvider({Key? key, Widget? child, this.bloc}) : super(key: key, child: child!);

  bool updateShouldNotify(_) => true;

  static AuthBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<AuthBlocProvider>()!).bloc;
  }
}