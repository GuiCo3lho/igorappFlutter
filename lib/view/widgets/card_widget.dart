import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IgorCard extends StatefulWidget {
  final bool animationForward;
  final double _sliderValue;
  final ImageProvider _image;
  final String _title;
  final String _textBody;
  final Function _onTap;

  IgorCard(
      this._image, this._title, this._textBody, this._sliderValue, this._onTap,
      {this.animationForward});

  @override
  State<StatefulWidget> createState() => _IgorCardState(
      this._image, this._title, this._textBody, this._sliderValue, this._onTap,
      animationForward: this.animationForward);
}

class _IgorCardState extends State<IgorCard>
    with SingleTickerProviderStateMixin {
  bool animationForward;
  Animation<double> _animation;
  AnimationController _controller;

  ImageProvider _image;
  double _sliderValue;
  String _title;
  String _textBody;
  final Function _onTap;

  _IgorCardState(
      this._image, this._title, this._textBody, this._sliderValue, this._onTap,
      {this.animationForward: false});

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _animation = Tween<double>(begin: 0, end: 0.8).animate(_controller);
  }

  @override
  void didUpdateWidget(IgorCard oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgorCardAnimated(this._image, this._title, this._textBody,
        this._sliderValue, this._onTap,
        animation: _animation);
  }
}

class IgorCardAnimated extends AnimatedWidget {
  final cardSize = 126.0;

  final ImageProvider _image;
  final String _title;
  final String _textBody;
  final double _sliderValue;
  final Function _onTap;

  IgorCardAnimated(
      this._image, this._title, this._textBody, this._sliderValue, this._onTap,
      {Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final _animation = listenable as Animation<double>;

    return GestureDetector(
      onTap: _onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1),
        width: MediaQuery.of(context).size.width,
        height: cardSize,
        foregroundDecoration: BoxDecoration(
            color: Color(Colors.black.value).withOpacity(_animation.value),
            backgroundBlendMode: BlendMode.darken),
        decoration: BoxDecoration(image: DecorationImage(image: _image)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15, left: 25, right: 25),
                  child: Text(_title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "FiraSans",
                          color: Colors.white)),
                ),
                Visibility(
                  visible: false,
                  child: Container(
                      margin: EdgeInsets.only(right: 25, top: 15),
                      child:
                          Icon(FontAwesomeIcons.trashAlt, color: Colors.white)),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 25, right: 25),
              child: Text(_textBody,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "FiraSans",
                      color: Colors.white)),
            ),
            SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  disabledActiveTrackColor: Colors.white,
                  disabledInactiveTrackColor: Colors.black,
                  trackHeight: 2.0,
                  disabledThumbColor: Colors.white,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
                ),
                child: Slider(value: this._sliderValue, onChanged: null)),
          ],
        ),
      ),
    );
  }
}
