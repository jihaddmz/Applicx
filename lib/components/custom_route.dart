import 'package:flutter/cupertino.dart';

class MyCustomRoute extends CupertinoPageRoute {
  MyCustomRoute(this.builder, this.settings, this.child)
      : super(builder: builder, settings: settings);

  WidgetBuilder builder;
  RouteSettings settings;
  Widget child;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(opacity: animation, child: child);
  }
}
