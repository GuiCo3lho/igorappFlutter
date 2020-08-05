import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:igor_app/bloc/application_state.dart';
import 'package:igor_app/model/adventure.dart';
import 'package:igor_app/model/player.dart';
import 'package:igor_app/view/util/util_colors.dart';

class InviteListScreen extends StatefulWidget {
  @override
  _InviteListScreenState createState() => _InviteListScreenState();
}

class _InviteListScreenState extends State<InviteListScreen> {
  Player _player = Player();

  @override
  Widget build(BuildContext context) {
    if (_player == null) {
      Firestore.instance
          .collection("users")
          .document(ApplicationState.state.user.uid)
          .get()
          .then((result) {
        _player = Player.fromJson(result.data);
      }).whenComplete(() => setState(() {}));
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Image.asset(
          "lib/assets/images/igor_logo.png",
          width: MediaQuery.of(context).size.width / 3,
        )),
      ),
      body: Container(
        color: IgorColors.darkBlack,
        child: FutureBuilder(
          future: Firestore.instance
              .collection("users")
              .document(ApplicationState.state.user.uid)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data != null) {
              _player = Player.fromJson(snapshot.data.data);

              if(_player.invites == null || _player.invites.isEmpty){
                return Center(child: Text("Nenhum convite", style: TextStyle(color: Colors.white)));
              }

              return ListView.builder(
                itemCount: _player.invites.length,
                itemBuilder: (BuildContext context, int index) {
                  return _createCard(
                      context, null, _player.invites[index].title, () {
                    _aceitarConvite(_player, _player.invites[index].id);
                  });
                },
              );
            } else {
              return Center(child: Text("Nenhum convite", style: TextStyle(color: Colors.white)));
            }
          },
        ),
      ),
    );
  }

  void _aceitarConvite(Player player, String adventureId) {
    Adventure adventure = player.invites.firstWhere((a) => a.id == adventureId);
    player.invites.remove(adventure);

    if (adventure.players == null) {
      adventure.players = List();
    }

    adventure.players.add(player);

    if (player.adventures == null) {
      player.adventures = List();
    }

    player.adventures.add(Adventure(id: adventure.id, title: adventure.title));

    Firestore.instance
        .collection("users")
        .document(player.id)
        .updateData(player.toJson())
        .whenComplete(() {
      adventure.players[0].adventures = null;
      adventure.players[0].invites = null;
      adventure.players[0].email = null;
      Firestore.instance
          .collection("adventures")
          .document(adventure.id)
          .updateData(adventure.toJson())
          .whenComplete(() {
        Navigator.of(context).pushReplacementNamed("/liveAdventures");
      });
    });
  }

  Widget _createCard(BuildContext context, String userName,
          String adventureName, onPressed) =>
      Card(
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    "Você foi convidado para participar da aventura $adventureName",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: onPressed,
                    color: Color(0xFF95E89A),
                    child: Text("Aceitar"),
                  ),
                )
              ],
            ),
          ));
}
