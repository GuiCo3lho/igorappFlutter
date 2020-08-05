import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igor_app/bloc/application_state.dart';
import 'package:igor_app/model/adventure.dart';
import 'package:igor_app/model/player.dart';
import 'package:igor_app/service/adventure_service.dart';
import 'package:igor_app/view/adventures/live_adventures_screen.dart';
import 'package:igor_app/view/util/util_colors.dart';
import 'package:igor_app/view/util/util_widgets.dart';
import 'package:http/http.dart' as http;

class NewAdventure extends StatefulWidget {
  @override
  _NewAdventureState createState() => _NewAdventureState();
}

class _NewAdventureState extends State<NewAdventure> {
  List<Player> _selected = List();
  List<Player> _players = List();
  Adventure _adventure = Adventure();
  AdventureService _adventureService = AdventureService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Firestore.instance.collection("users").getDocuments().then((snap) {
      if (_players.length == 0) {
        snap.documents
            .forEach((user) => _players.add(Player.fromJson(user.data)));
      }
    }).then((a) {
      _players
          .removeWhere((user) => user.id == ApplicationState.state.user.uid);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            color: IgorColors.paleBlue,
            child: Stack(children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 140),
                height: 400,
                width: MediaQuery.of(context).size.width - 40,
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 15, top: 15),
                          child: Icon(
                            FontAwesomeIcons.times,
                            size: 16,
                          )),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 15),
                        child: Text("Criar Aventura",
                            style: TextStyle(
                                color: IgorColors.lightBlue,
                                fontSize: 14,
                                decoration: TextDecoration.none)),
                      )
                    ]),
                    Container(
                      margin: EdgeInsets.only(left: 30, top: 20),
                      child: Text("De um nome para a sua aventura",
                          style: TextStyle(
                              color: IgorColors.lightGray,
                              fontSize: 12,
                              decoration: TextDecoration.none)),
                    ),
                    ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Form(
                            key: _formKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Util.createTextFormField("nome da aventura",
                                      validator: (value) => value.isEmpty
                                          ? "Campo obrigatório!"
                                          : null,
                                      onSaved: (value) =>
                                          _adventure.title = value),
                                  Text(
                                      "Adicionar jogadores (máx 10 jogadores)"),
                                  ListView(shrinkWrap: true, children: [
                                    Util.createNCheckBoxColumn(
                                        _selected, _players, _isPresent,
                                        (actualValue, player) {
                                      setState(() {
                                        if (actualValue &&
                                            _selected.length <= 10) {
                                          _selected.add(player);
                                        } else {
                                          _selected.remove(player);
                                        }
                                      });
                                    })
                                  ])
                                ])),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.only(top: 15, right: 20),
                        child: RaisedButton(
                            child: Text("PRONTO",
                                style: TextStyle(color: Colors.white)),
                            color: IgorColors.darkBlue,
                            onPressed: () => _saveForm()),
                      ),
                    )
                  ],
                ),
              )
            ]),
          )
        ]),
      );

  void _saveForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      FirebaseUser user = ApplicationState.state.user;

      _adventure.ownerPlayer = Player(id: user.uid);
      _adventure.players = null;
      _adventure.ownerPlayer.adventures = null;
      _adventure.ownerPlayer.invites = null;
      _adventure.ownerPlayer.invites = null;

      Firestore.instance.collection("adventures").add(_adventure.toJson()).then(
          (result) {
        _adventure.id = result.documentID;
        Firestore.instance
            .collection("adventures")
            .document(result.documentID)
            .updateData({"id": result.documentID});
      }).whenComplete(() {
        _selected.forEach((user) async {
          await Firestore.instance
              .collection("users")
              .document(user.id)
              .get()
              .then((document) {
            Player playerDB = Player.fromJson(document.data);

            if (playerDB.invites == null) {
              playerDB.invites = List<Adventure>();
            }

            playerDB.invites.add(_adventure);

            Firestore.instance
                .collection("users")
                .document(playerDB.id)
                .updateData(playerDB.toJson());

            _sendNotification(user);
          });
        });
      }).whenComplete(() =>
          ApplicationState.state.pushReplacement(context, "/liveAdventures"));
    }
  }

  bool _isPresent(Player valor, List<Player> lista) {
    if (lista == null || lista.isEmpty) {
      return false;
    }

    for (var v in lista) {
      if (valor.id == v.id) {
        return true;
      }
    }

    return false;
  }

  Future _sendNotification(Player receiver) async {
    String serverToken =
        "AAAAt-YA3RE:APA91bEXyE8DrzvqeRvafdFh70MU4CNHpNscM-5m1qdLoC0vGX3gWn8XgYHfyalIHTA"
        "1S6RAlyxOcRtxyGFRblS4XFofD5lmP7k05fHaWZS8xULrAjpd718iUDoRxovNbsgt9M0mQXrN";

    String topic = receiver.id;
    http
        .post('https://fcm.googleapis.com/fcm/send',
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$serverToken',
            },
            body: jsonEncode(<String, dynamic>{
              'notification': <String, dynamic>{
                'title': 'Você foi convidado para uma aventura!',
                'body': 'Você foi convidado para uma aventura!'
              },
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done'
              },
              'to': '/topics/$topic'
            }))
        .then((response) => print("[$response.statusCode] Mensagem enviada!"));
  }
}
