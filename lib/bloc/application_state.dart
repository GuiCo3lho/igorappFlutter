import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:gen_lang/print_tool.dart';

class ApplicationState {
  FirebaseUser user;

  bool isUserLogged() => user != null;

  static final ApplicationState state = ApplicationState._internal();
  factory ApplicationState() => state;

  Future pushReplacement(BuildContext context, String routeName) {
    if (!isUserLogged()) {
      printError("Attempt to access a page without login!");
      return Navigator.of(context).pushReplacementNamed("/signInPage");
    }

    return Navigator.of(context).pushReplacementNamed(routeName);
  }

  Future pushNamed(BuildContext context, String routeName) {
    if (!isUserLogged()) {
      printError("Attempt to access a page without login!");
      return Navigator.of(context).pushReplacementNamed("/signInPage");
    }

    return Navigator.of(context).pushNamed(routeName);
  }

  ApplicationState._internal() {
    debugPrint("Application state singleton created!\n");
  }
}
