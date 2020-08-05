import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:igor_app/bloc/application_state.dart';
import 'package:igor_app/model/player.dart';
import 'package:igor_app/view/util/util_colors.dart';
import 'package:igor_app/view/util/util_widgets.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Player _player = Player();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Material(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            Image.asset("lib/assets/images/login_bg.png").image,
                        fit: BoxFit.fill)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 60, bottom: 40),
                        child: Image.asset("lib/assets/images/igor_logo.png",
                            width: MediaQuery.of(context).size.width / 2),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          color: Colors.white,
                          child: Form(
                            key: _formKey,
                            child: Column(children: <Widget>[
                              Util.createTextFormField(
                                "E-mail",
                                validator: (input) => input.isEmpty
                                    ? "Please type an email"
                                    : null,
                                onSaved: (input) => _player.email = input,
                              ),
                              Util.createTextFormField(
                                "Senha",
                                validator: (input) {
                                  if (input.isEmpty) {
                                    return "Please type an password";
                                  } else if (input.length < 6) {
                                    return 'Your password needs to be at least 6 chars';
                                  }
                                  return null;
                                },
                                onSaved: (input) => _player.password = input,
                                obscureText: true,
                              ),
                              Util.createTextFormField("Nome/Apelido",
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return "This is obrigatory!";
                                    }
                                    return null;
                                  },
                                  onSaved: (input) => _player.name = input),
                              Container(
                                margin: EdgeInsets.only(right: 50),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    RaisedButton(
                                        color: IgorColors.brightBlue,
                                        child: Text("CRIAR",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        onPressed: signUp),
                                  ],
                                ),
                              ),
                            ]),
                          ))
                    ]))),
      );

  Future<void> signUp() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      //verifica as validações feitas no Form
      formState.save(); //salva as variaveis no state

      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _player.email, password: _player.password)
          .then((auth) {
        ApplicationState.state.user = auth.user;
        _player.id = auth.user.uid;
        _player.password = null;
        Firestore.instance
            .collection("users")
            .document(_player.id)
            .setData(_player.toJson());
      }).whenComplete(() => ApplicationState.state
              .pushReplacement(context, "/liveAdventures"));
    }
  }
}
