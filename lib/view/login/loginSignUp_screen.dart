import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:igor_app/view/formUser/root_screen.dart';

import '../../service/authentication.dart';



class LoginScreen extends StatefulWidget {
  LoginScreen({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _password,_email;
  bool _isLoading;

  final _formKey = new GlobalKey<FormState>();
  bool _isLoginForm = false;
  String _errorMessage = 'Hahahahah';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Igor Login Page"),
      ),
      body: Stack(
        children: <Widget>[showform(),
          ],
      )
    );
  }

Widget showform(){

    String texto = "TESTEEEEEE";
  return Container(
    padding: EdgeInsets.all(16.0),
    child: Form(
      key: _formKey,

      child:  _isLoginForm ? ListView(
        shrinkWrap: true,
        children: <Widget>[showLogo(),
        showEmailInput(),
        showPasswordInput(),
        showPrimaryButton(),
        showSecondaryButton(),
        showErrorMessage()],

      ) : ListView(children: <Widget>[
        showLogo(),
        showEmailInput(),
        showPasswordInput(),
        showPrimaryButton()


  ]
  ),
  ),
  );

}

Widget showCircularProgress(){
  if(_isLoading){
    return Center(child: CircularProgressIndicator());
  }
  return Container(
    height: 0.0,
    width: 0.0,
  );
}

Widget showLogo(){
  return new Hero(
    tag: 'hero',
    child: Padding(
      padding: EdgeInsets.fromLTRB(0.0, 70.0 , 0, 0),
      child: CircleAvatar(
    backgroundColor: Colors.transparent,
  radius: 48.0,
  child: Image.asset('lib/assets/images/igor_logo.png'),
  ),
  ),
  );
}

Widget showEmailInput(){

  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 100,0, 0),
    child: TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        icon: new Icon(
          Icons.mail,
          color: Colors.grey,
        )
      ),
      validator: (value) => value.isEmpty ? 'Email cant be empty' : null,
      onSaved: (value) => _email = value.trim(),
    )
  );
}

Widget showPasswordInput(){
  return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15.0,0, 0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )
        ),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      )
  );
}

Widget showPrimaryButton(){

  return Padding(
    padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
    child: SizedBox(
      height: 40.0,
      child: RaisedButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)),
        color: Colors.deepPurple,
        child: Text(_isLoginForm ? 'Login' : 'Create Account',
          style: TextStyle(fontSize: 20.0, color: Colors.white)),
        onPressed: validateAndSubmit,
        )
      ),

    );

}

Widget showSecondaryButton(){

  return FlatButton(
    child: Text(
      _isLoginForm ? 'Create an Account' : 'Have an account? Sign in',
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)
    ),
    onPressed: toggleFormMode
  );
}

void toggleFormMode(){
  setState(() {
    _isLoginForm = !_isLoginForm;
  });
}

Widget showErrorMessage() {

  if (_errorMessage.length > 0 && _errorMessage != null) {
    return new Text(
      _errorMessage,
      style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300),
    );
  } else {
    return new Container(
      height: 0.0,
    );
  }
}


  Widget signedOut() {

    setState(() {
      _isLoginForm = !_isLoginForm;
    });
    return LoginScreen();

  }





  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }



  static Widget createTextFormField(String hintText,
      {double top: 8.0,
        double bottom: 8.0,
        TextInputType textInputType,
        bool obscureText: false,
        void Function(String) onSaved,
        String Function(String) validator,
        TextEditingController controller}) {
    return Container(
        child: TextFormField(
          controller: controller,
          onSaved: onSaved,
          validator: validator,
          keyboardType: textInputType,
          obscureText: obscureText,
          decoration: InputDecoration(hintText: hintText),
        ),
        margin:
        EdgeInsets.only(left: 24.0, right: 24.0, top: top, bottom: bottom));
  }


  Future<Widget> validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          print('Signed up user: $userId');
          return RootPage();
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }


}