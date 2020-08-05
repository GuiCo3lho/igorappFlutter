import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gen_lang/print_tool.dart';
import 'package:igor_app/view/adventures/invite_list_screen.dart';
import 'package:igor_app/view/adventures/live_adventures_screen.dart';
import 'package:igor_app/view/adventures/new_adventure_screen.dart';
import 'package:igor_app/view/adventures/view_adventure_screen.dart';
import 'package:igor_app/view/intro/login_screen.dart';
import 'package:igor_app/view/intro/signUp_screen.dart';
import 'package:igor_app/view/intro/splash_screen.dart';

void main() => runApp(IgorApp());

class IgorRoute {
  final IconData iconData;
  final String menuLabel;
  final String path;
  final Widget Function(BuildContext) function;

  IgorRoute(this.iconData, this.menuLabel, this.path, this.function);

  static toMap(List<IgorRoute> routes) => Map.fromIterables(
      routes.map((k) => k.path), routes.map((v) => v.function));
}

class IgorApp extends StatefulWidget {
  static List<IgorRoute> routes = [
    IgorRoute(FontAwesomeIcons.bookOpen, "Aventuras", "/listAdventures",
        (context) => LiveAdveturesScreen())
  ];

  @override
  _IgorAppState createState() => _IgorAppState();
}

class _IgorAppState extends State<IgorApp> {
  @override
  void dispose() {
    // TODO: implement dispose
    printError("!!!!!!!!!! DISPOSE CALLED !!!!!!!!!!!!!!!!!");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Igor App',
        //routes: IgorRoute.toMap(routes),
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: "FiraSans",
        ),
        home: SplashScreen(),
        routes: {
          '/signInPage': (context) => LoginScreen(),
          '/liveAdventures': (context) => LiveAdveturesScreen(),
          '/signUpPage': (context) => SignUpScreen(),
          '/newAdventure': (context) => NewAdventure(),
          '/viewAdventure': (context) => ViewAdventure(),
          '/inviteList': (context) => InviteListScreen(),
        },
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case ViewAdventure.route:
              return MaterialPageRoute(
                  builder: (ctx) =>
                      ViewAdventure(adventureId: settings.arguments as String),
                  settings: settings);
              break;
            default:
              printError("Route not registered!");
              return null;
              break;
          }
        },
      );
}
