// Source code from: https://www.didierboelens.com/2018/12/reactive-programming---streams---bloc---practical-use-cases/

import 'package:flutter/widgets.dart';

Type _typeOf<T>() => T;

abstract class BlocBase {
  void dispose();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final T bloc;
  final Widget child;

  const BlocProvider({Key key, this.bloc, this.child}) : super(key: key);

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<_BlocProviderInherited<T>>();
    _BlocProviderInherited<T> provider =
        context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;
    return provider?.bloc;
  }
}

class _BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {
  @override
  void dispose() {
    widget.bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _BlocProviderInherited<T>(bloc: widget.bloc, child: widget.child);
}

class _BlocProviderInherited<T> extends InheritedWidget {
  final T bloc;

  _BlocProviderInherited({
    Key key,
    @required Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
