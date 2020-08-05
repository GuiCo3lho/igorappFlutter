import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:igor_app/bloc/application_state.dart';
import 'package:igor_app/model/player.dart';
import 'package:igor_app/view/util/util_colors.dart';
import 'package:igor_app/view/widgets/firebase_notifications.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future cacheAssetImage(BuildContext context, String imageName) async =>
      precacheImage(Image.asset("lib/assets/images/$imageName").image, context)
          .whenComplete(() => print("$imageName was precached!"));

  Future loadImages(BuildContext context) async {
    await cacheAssetImage(context, "adv_bg1.png");
    await cacheAssetImage(context, "adv_bg2.png");
    await cacheAssetImage(context, "adv_bg3.png");
    await cacheAssetImage(context, "adv_bg4.png");
    await cacheAssetImage(context, "adv_bg5.png");
    await cacheAssetImage(context, "igor_logo.png");
    await cacheAssetImage(context, "login_bg.png");

    FirebaseAuth.instance.currentUser().then((firebaseUser) async {
      if (firebaseUser != null) {
        ApplicationState.state.user = firebaseUser;
        FirebaseNotifications().setUpFirebase().whenComplete(() {
          print("An user was identified as logged! ${firebaseUser.email}");
          Navigator.of(context).pushReplacementNamed('/liveAdventures');
        });
      } else {
        Navigator.of(context).pushReplacementNamed('/signInPage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    loadImages(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.asset("lib/assets/images/login_bg.png").image,
              fit: BoxFit.fill)),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 30),
            child: Image(
              image: Image.asset("lib/assets/images/igor_logo.png").image,
              width: MediaQuery.of(context).size.width / 2,
            ),
          ),
          CircularProgressIndicator(
            backgroundColor: IgorColors.darkPink,
          ),
        ],
      )),
    );
  }
}
