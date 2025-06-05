import "package:flutter/material.dart";
import "package:utilities/helpers/tuples.dart";

/// [MainBottomNavBar] is a class that defines the main bottom navigation bar of the app.
class MainBottomNavBar extends StatelessWidget {
  /// [iconButtons] is a list of [IconData] and [void Function()] pairs, used for navigating app features.
  final List<Pair<IconData, void Function()>> iconButtons;

  /// [MainBottomNavBar] constructor.
  const MainBottomNavBar({
    super.key,
    required this.iconButtons,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: iconButtons
          .map(
            (e) => IconButton(
              iconSize: 30,
              onPressed: e.second,
              icon: Icon(e.first),
            ),
          )
          .toList(),
    );
  }
}
