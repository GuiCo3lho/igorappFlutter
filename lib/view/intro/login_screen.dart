import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igor_app/bloc/application_state.dart';
import 'package:igor_app/view/adventures/live_adventures_screen.dart';
import 'package:igor_app/view/util/util_colors.dart';
import 'package:igor_app/view/util/util_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Material(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: Image.asset("lib/assets/images/login_bg.png").image,
                    fit: BoxFit.fill)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 60, bottom: 40),
                    child: Image.asset("lib/assets/images/igor_logo.png",
                        width: MediaQuery.of(context).size.width / 2),
                  ),
                  RaisedButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(FontAwesomeIcons.facebookSquare)),
                        Text("Log in with Facebook"),
                      ],
                    ),
                    onPressed: () => print("Logging with facebook"),
                    color: IgorColors.facebookButton,
                    textColor: Colors.white,
                    elevation: 3,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text("OU",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300)),
                  ),
                  Container(
                      child: Form(
                          key: _formKey,
                          child: Column(children: <Widget>[
                            Theme(
                                data: Theme.of(context).copyWith(
                                    inputDecorationTheme: InputDecorationTheme(
                                        hintStyle:
                                            TextStyle(color: Colors.white)),
                                    textTheme: TextTheme(
                                        title: TextStyle(color: Colors.white))),
                                child: Column(children: <Widget>[
                                  Util.createTextFormField(
                                    "Login",
                                    validator: (input) {
                                      // ignore: missing_return

                                      if (input.isEmpty) {
                                        return "Please type an email";
                                      }
                                    },
                                    onSaved: (input) => _email = input,
                                  ),
                                  Util.createTextFormField(
                                    "Password",
                                    validator: (input) {
                                      // ignore: missing_return

                                      if (input.isEmpty) {
                                        return "Please type an password";
                                      } else {
                                        if (input.length < 6) {
                                          return 'Your password needs to be at least 6 chars';
                                        }
                                      }
                                    },
                                    onSaved: (input) => _password = input,
                                    obscureText: true,
                                  )
                                ])),
                            Container(
                              margin: EdgeInsets.only(right: 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  RaisedButton(
                                      color: IgorColors.brightBlue,
                                      child: Text("ENTRAR",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      onPressed: signIn),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                  left: 60, top: 10, bottom: 20),
                              child: GestureDetector(
                                onTap: () => Navigator.of(context)
                                    .pushNamed("/signUpPage"),
                                child: Text("criar conta",
                                    style: TextStyle(
                                        color: IgorColors.brightBlue,
                                        fontSize: 14)),
                              ),
                            ),
                          ])))
                ]),
          )));

  Future<void> signIn() async {
    //TODO validate fields
    final formState = _formKey.currentState;
    if (formState.validate()) {
      //verifica as validações feitas no Form
      formState.save(); //salva as variaveis no state
      try {
        AuthResult result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        ApplicationState.state.user = result.user;
        ApplicationState.state.pushReplacement(context, '/liveAdventures');
      } catch (e) {
        print(e);
      }
    }
  }
}
