import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gen_lang/print_tool.dart';
import 'package:igor_app/bloc/application_state.dart';
import 'package:igor_app/view/adventures/live_adventures_screen.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  static List<String> tokens = List();

  Future setUpFirebase() async {
    _firebaseMessaging = FirebaseMessaging();
    await firebseCloudMessagingListeners();
  }

  Future firebseCloudMessagingListeners() async {
    if (Platform.isAndroid && ApplicationState.state.isUserLogged()) {
      print("Listening to push notifications!");
      _firebaseMessaging
          .subscribeToTopic(ApplicationState.state.user.uid)
          .whenComplete(() {
        _firebaseMessaging.configure(
            onResume: (Map<String, dynamic> message) async {
          print("on resume $message");
        }, onMessage: (Map<String, dynamic> message) async {
          print("on message $message");
        }, onLaunch: (Map<String, dynamic> message) async {
          print("on launch $message");
        });
      });
    } else {
      printError("Configured to work only with Android!");
      return Future.error(null);
    }
  }
}
