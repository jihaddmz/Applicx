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
    return FadeTransition(
        opacity: Tween<double>(
          begin: 0.5,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut, // You can change the curve as needed
          ),
        ),
        child: child);
  }
}
