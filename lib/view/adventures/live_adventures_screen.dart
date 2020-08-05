import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igor_app/bloc/adventure_bloc.dart';
import 'package:igor_app/bloc/application_state.dart';
import 'package:igor_app/bloc/bloc_provider.dart';
import 'package:igor_app/model/adventure.dart';
import 'package:igor_app/view/adventures/view_adventure_screen.dart';
import 'package:igor_app/view/util/util_colors.dart';
import 'package:igor_app/view/util/util_widgets.dart';
import 'package:igor_app/view/widgets/card_widget.dart';

class LiveAdveturesScreen extends StatefulWidget {
  const LiveAdveturesScreen({Key key}) : super(key: key);

  @override
  LiveAdveturesScreenState createState() => LiveAdveturesScreenState();
}

class LiveAdveturesScreenState extends State<LiveAdveturesScreen> {
  bool isEditMode;
  final String editValue = "edit";
  final String orderValue = "order";
  int imageIndex = 0;
  final int limitQuery = 10;

  final Random random = Random();
  List<Adventure> _adventures = List();

  @override
  Widget build(BuildContext context) => Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            ApplicationState.state.pushNamed(context, "/newAdventure"),
        child: Icon(
          FontAwesomeIcons.mapMarkedAlt,
          color: Colors.black,
        ),
        backgroundColor: IgorColors.paleYellow,
      ),
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<String>(
            offset: Offset(0, 80),
            onSelected: (value) {
              final AdventureBloc bloc =
                  BlocProvider.of<AdventureBloc>(context);
              bloc.listAdventuresStream.sink
                  .add(Mode.values.where((v) => v.toString() == value).first);
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<String>(child: Text("Editar"), value: editValue),
                PopupMenuItem<String>(child: Text("Ordenar"), value: orderValue)
              ];
            },
          )
        ],
        title: Center(
            child: Image.asset(
          "lib/assets/images/igor_logo.png",
          width: MediaQuery.of(context).size.width / 3,
        )),
      ),
      drawer: Util.createDrawer(context),
      body: Container(
        color: IgorColors.darkBlack,
        child: FutureBuilder(
            future: Firestore.instance
                .collection("adventures")
                .limit(limitQuery)
                .getDocuments(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data.documents.isEmpty) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                        child: Text(
                      "Sem aventuras cadastradas!",
                      style: TextStyle(color: Colors.white70),
                    )));
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    Adventure adv =
                        Adventure.fromJson(snapshot.data.documents[index].data);
                    _adventures.add(adv);

                    return IgorCard(
                        Image.asset("lib/assets/images/adv_bg" +
                                ((imageIndex++ % 5) + 1).toString() +
                                ".png")
                            .image,
                        adv.title,
                        "próxima sessão 12/11",
                        random.nextDouble(),
                        () => Navigator.of(context)
                            .pushNamed(ViewAdventure.route, arguments: adv.id));
                  },
                );
              }

              return Container(
                  margin: EdgeInsets.only(top: 100),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CircularProgressIndicator(
                          backgroundColor: IgorColors.darkPink),
                      Text("Carregando...",
                          style: TextStyle(color: Colors.white70))
                    ],
                  )));
              // }
            }),
      ));
}
