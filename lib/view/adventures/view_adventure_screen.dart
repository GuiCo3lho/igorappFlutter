import 'package:flutter/material.dart';
import 'package:igor_app/model/adventure.dart';
import 'package:igor_app/service/adventure_service.dart';

class CustomButtonPainter extends CustomPainter {
  final Color color;

  CustomButtonPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = this.color;

    double division = size.width / 4;

    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(division, 0);
    path.lineTo(size.width - division, 0);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ViewAdventure extends StatelessWidget {
  final String adventureId;
  Adventure _adventure;
  AdventureService _adventureService = AdventureService();
  static const String route = "/ViewAdventure";

  ViewAdventure({Key key, this.adventureId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _adventureService.getById(adventureId);

    print("Adventure id: $adventureId");
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.asset("lib/assets/images/login_bg.png").image,
                alignment: Alignment.topCenter,
                fit: BoxFit.fill)),
        child: Column(children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 70, right: 80),
              child: Text(
                "Aventura sem título",
                style: TextStyle(
                    fontFamily: "FiraSans",
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 16,
                    decoration: TextDecoration.none),
              )),
          AdventureViewerWidget()
        ]));
  }
}

class AdventureViewerWidget extends StatefulWidget {
  @override
  _AdventureViewerWidgetState createState() => _AdventureViewerWidgetState();
}

class _AdventureViewerWidgetState extends State<AdventureViewerWidget> {
  final Color activeButton = Color.fromARGB(0xFF, 226, 226, 224);
  final Color inactiveButton = Color.fromARGB(0xFF, 157, 183, 182);

  final String andamentoLabel = "ANDAMENTO";
  final String jogadoresLabel = "JOGADORES";
  Widget buttonSelected;
  Widget child;

  List<Widget> buttons;

  _AdventureViewerWidgetState() {
    this.buttons = [
      _createButtonWidget(jogadoresLabel, Alignment.centerRight,
          color: inactiveButton),
      _createButtonWidget(andamentoLabel, Alignment.centerLeft,
          color: activeButton)
    ];
    buttonSelected = this.buttons.last;
    child = _getDescriptionChild();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 30, right: 30, top: 50),
        child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Container(
              child: Stack(
                  alignment: Alignment.centerLeft, children: this.buttons)),
          Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              width: double.infinity,
              height: 200,
              color: activeButton,
              child: child)
        ]));
  }

  Widget _createButton(String buttonText) => Container(
      margin: EdgeInsets.fromLTRB(50, 15, 50, 15),
      child: Text(
        buttonText,
        style: TextStyle(
            color: Colors.black, decoration: TextDecoration.none, fontSize: 12),
      ));

  Widget _createButtonWidget(String buttonLabel, Alignment alignment,
      {color: const Color.fromARGB(0xFF, 157, 183, 182)}) {
    Widget button = _createButton(buttonLabel);

    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () {
          if (button != buttonSelected) {
            setState(() {
              buttonSelected = button;
              buttons.clear();

              if (buttonLabel == andamentoLabel) {
                buttons.add(_createButtonWidget(
                    jogadoresLabel, Alignment.centerRight,
                    color: inactiveButton));
                buttons.add(_createButtonWidget(
                    andamentoLabel, Alignment.centerLeft,
                    color: activeButton));
                child = _getDescriptionChild();
              } else if (buttonLabel == jogadoresLabel) {
                buttons.add(_createButtonWidget(
                    andamentoLabel, Alignment.centerLeft,
                    color: inactiveButton));
                buttons.add(_createButtonWidget(
                    jogadoresLabel, Alignment.centerRight,
                    color: activeButton));
                child = _getPlayersChild();
              }
            });
          }
        },
        child: CustomPaint(
            willChange: true,
            painter: CustomButtonPainter(color),
            child: Container(child: _createButton(buttonLabel))),
      ),
    );
  }

  Widget _getPlayersChild() => Container(
          child: ListView(
        children: <Widget>[
          _createPlayerItem("Mestre Marcio", "Mestre impiedoso"),
          Divider(),
          _createPlayerItem("D4RK 4VENGER", "Bruno"),
          Divider()
        ],
      ));

  Container _createPlayerItem(String title, String description) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.greenAccent)),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[_createText(title)],
                ),
                _createText(description)
              ],
            ),
          )
          // Column(
          //   children: <Widget>[
          //     Text("mestre nome"),
          //     Text("descrição aleatória")
          // ],
          // )
        ],
      ),
    );
  }

  Widget _getDescriptionChild() => Container(
          child: ListView(children: [
        Text(_getFakeText(),
            style: TextStyle(
                fontSize: 12,
                decoration: TextDecoration.none,
                color: Colors.black,
                fontFamily: "FiraSans"))
      ]));

  Widget _createText(String text) => Text(text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textWidthBasis: TextWidthBasis.parent,
      style: TextStyle(
          fontFamily: "FiraSans",
          fontSize: 12,
          color: Colors.black,
          decoration: TextDecoration.none));

  String _getFakeText() =>
      "Mas devo explicar-lhe como nasceu toda essa idéia equivocada de denunciar um prazer e louvar a dor, e lhe darei um relato completo do sistema, expondo os ensinamentos reais do grande explorador da verdade, o mestre-construtor. da felicidade humana. Ninguém rejeita, não gosta, ou evita o prazer em si, porque é prazer, mas porque aqueles que não sabem como buscar prazer encontram racionalmente conseqüências que são extremamente dolorosas. Tampouco há alguém que ame, busque ou deseje obter dor de si mesmo, porque é dor, mas ocasionalmente ocorrem circunstâncias em que a labuta e a dor podem lhe proporcionar um grande prazer. Para dar um exemplo trivial, qual de nós empreende algum exercício físico laborioso, exceto para obter alguma vantagem disso? Mas quem tem o direito de criticar um homem que escolhe desfrutar de um prazer que não tem conseqüências irritantes, ou alguém que evita uma dor que não produz prazer resultante?";
}
