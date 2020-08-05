import 'dart:async';

import 'package:igor_app/bloc/bloc_provider.dart';

enum Mode { EDIT, VIEW }

class AdventureBloc implements BlocBase {
  final StreamController<Mode> listAdventuresStream =
      StreamController<Mode>.broadcast();

  @override
  void dispose() {
    listAdventuresStream.close();
  }
}
