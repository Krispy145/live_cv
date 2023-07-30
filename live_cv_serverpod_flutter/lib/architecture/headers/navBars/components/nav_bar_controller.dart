import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/architecture/structure.dart';
import 'package:live_cv_serverpod_flutter/architecture/headers/navBars/components/nav_bar_item.dart';
import 'package:live_cv_serverpod_flutter/helpers/buttons/import.dart';

/// Defines which type of Navbar the view is using.

/// This will determine where the navbar icon/widget will be placed.
enum NavBarType { left, right, full }

/// Defines which type of Navbar Drawer the view is using.

/// This will determine which direction the NavbarMenu animates.
enum MenuType { left, right, full }

/// [NavBarController] controller to control aspects of the Navbar:
class NavBarController extends ChangeNotifier {
  List<NavbarItem> textItems;
  List<Button> buttonItems;
  String _selectedPath = '/';

  NavBarController({this.buttonItems = const [], this.textItems = const []});
  String get selectedPath => _selectedPath;

  /// Sets the selected nav bar item by its index
  void setSelectedItem(String path) {
    _selectedPath = path;
    notifyListeners();
  }

  /// Returns the nav bar actions
  ///
  /// Starts with all text actions ([NavbarItem]), followed by button actions ([Button])
  List<Widget> get navBarItems {
    List<Widget> result = [];
    if (textItems.isNotEmpty) result.addAll(textItems);
    if (buttonItems.isNotEmpty) result.addAll(buttonItems);
    return result;
  }

  /// Returns whether the bottom nav bar is open
  bool _isBottomNavbarOpen = false;

  /// Returns whether the nav bar menu is open
  bool isOpen(MenuType type) {
    switch (type) {
      case MenuType.left:
        return scaffoldKey.currentState?.isDrawerOpen ?? false;

      case MenuType.right:
        return scaffoldKey.currentState?.isEndDrawerOpen ?? false;

      case MenuType.full:
        return _isBottomNavbarOpen;
    }
  }

  /// Opens the nav bar menu nav bar
  ///
  /// This will either be a drawer or a bottom nav bar, depending on the [MenuType]
  void open(MenuType type) {
    switch (type) {
      case MenuType.left:
        scaffoldKey.currentState?.openDrawer();
        break;
      case MenuType.right:
        scaffoldKey.currentState?.openEndDrawer();
        break;
      case MenuType.full:
        onOpenChangedHandler?.call(true);
        _isBottomNavbarOpen = true;
        notifyListeners();
        break;
    }
  }

  /// Closes the nav bar drawer / bottom nav bar
  void close(MenuType type) {
    switch (type) {
      case MenuType.left:
        scaffoldKey.currentState?.closeDrawer();
        break;
      case MenuType.right:
        scaffoldKey.currentState?.closeEndDrawer();
        break;
      case MenuType.full:
        onOpenChangedHandler?.call(false);
        _isBottomNavbarOpen = false;
        notifyListeners();
        break;
    }
  }

  /// A callback to setup opening / closing a bottom nav bar from within the [YBottomNavbar] class
  void Function(bool open)? onOpenChangedHandler;
}
