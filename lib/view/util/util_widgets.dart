import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igor_app/model/player.dart';
import 'package:igor_app/view/util/util_colors.dart';

class Util {
  static Widget createDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.only(top: 25),
        color: IgorColors.darkPurple,
        child: ListView(
          children: [
            ListTile(
                title: Text("Aventuras",
                    style: TextStyle(
                        color: IgorColors.lightYellow, fontFamily: "FiraSans")),
                leading: Icon(
                  FontAwesomeIcons.bookOpen,
                  color: IgorColors.lightYellow,
                )),
            ListTile(
                onTap: () =>
                    Navigator.of(context).pushNamed("/inviteList"),
                title: Text("Lista de convites",
                    style: TextStyle(
                        color: IgorColors.lightYellow, fontFamily: "FiraSans")),
                leading: Icon(
                  FontAwesomeIcons.bookOpen,
                  color: IgorColors.lightYellow,
                )),
            ListTile(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed("/signInPage");
                },
                title: Text("Sair",
                    style: TextStyle(
                        color: IgorColors.lightYellow, fontFamily: "FiraSans")),
                leading: Icon(
                  FontAwesomeIcons.bookOpen,
                  color: IgorColors.lightYellow,
                )),
          ],
        ),
      ),
    );
    // final DrawerBloc bloc = BlocProvider.of<DrawerBloc>(context);
    // return StreamBuilder(
    //     initialData: IgorApp.routes.first.menuLabel,
    //     stream: bloc.drawerStream.stream,
    //     builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
    //         );
  }

  static RaisedButton createRaisedButton(String text, Function onPressed,
      {double padding: 40.0}) {
    return RaisedButton(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Text(
          text,
          style: TextStyle(
              fontFamily: "Roboto", fontSize: 12.0, color: Colors.black),
        ),
      ),
      onPressed: onPressed,
    );
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
            EdgeInsets.only(left: 48.0, right: 48.0, top: top, bottom: bottom));
  }

  static Widget createNCheckBoxColumn(
      List<Player> listaCheckBoxEntidade,
      List<Player> checkBoxValueLabel,
      bool Function(Player, List<Player>) isPresent,
      void Function(bool, Player) onChange) {
    List<Widget> listOfRows = List();

    for (int i = 0; i < checkBoxValueLabel.length; i++) {
      listOfRows.add(Row(
        children: <Widget>[
          Checkbox(
            activeColor: IgorColors.darkBlack,
            value: isPresent(checkBoxValueLabel[i], listaCheckBoxEntidade),
            onChanged: onChange == null
                ? null
                : (v) => onChange(v, checkBoxValueLabel[i]),
          ),
          Text(checkBoxValueLabel[i].name)
        ],
      ));
    }

    return Container(
        margin: EdgeInsets.only(left: 10.0),
        child: Column(children: listOfRows));
  }
}
