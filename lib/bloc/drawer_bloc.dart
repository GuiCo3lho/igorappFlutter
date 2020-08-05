import 'dart:async';

import 'package:flutter/material.dart';
import 'package:igor_app/bloc/bloc_provider.dart';

class DrawerOption {
  final String label;
  final String path;
  final Widget Function(BuildContext) navigator;

  DrawerOption(this.label, this.path, this.navigator);
}

class DrawerBloc implements BlocBase {
  static List<DrawerOption> routes = [
    DrawerOption("Aventuras", "/aventuras", null)
  ];

  final StreamController<String> drawerStream = StreamController<String>.broadcast();

  @override
  void dispose() {
    drawerStream.close();
  }
}
