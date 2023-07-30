import 'package:flutter/material.dart';

/// Abstract class [Footer] for all Footers to be built from
abstract class Footer extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;

  const Footer({super.key, this.backgroundColor});
}
