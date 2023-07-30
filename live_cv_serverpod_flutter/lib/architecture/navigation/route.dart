import 'package:flutter/material.dart';

class NewRoute {
  final String path;
  final Widget? Function(BuildContext? context) handler;

  const NewRoute({required this.path, required this.handler});
}
