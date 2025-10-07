import "package:cv_app/dependencies/injection.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";

/// [AnimatedThemeToggle] is a widget that provides an animated transition
/// between sun and moon icons when toggling between light and dark themes.
class AnimatedThemeToggle extends StatefulWidget {
  /// [AnimatedThemeToggle] constructor.
  const AnimatedThemeToggle({
    super.key,
    this.size = 24,
    this.color,
  });

  /// [size] is the size of the icon.
  final double size;

  /// [color] is the color of the icon. If null, uses the theme's onSurface color.
  final Color? color;

  @override
  State<AnimatedThemeToggle> createState() => _AnimatedThemeToggleState();
}

class _AnimatedThemeToggleState extends State<AnimatedThemeToggle> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.8,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.5, curve: Curves.easeInOut),
      ),
    );

    // Set initial state based on current theme
    // Use WidgetsBinding.instance.addPostFrameCallback to ensure theme is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Show what we would switch TO, not current state
        if (Managers.themeStateStore.isDark) {
          // Currently dark, so show sun (would switch to light)
          _animationController.value = 0;
        } else {
          // Currently light, so show moon (would switch to dark)
          _animationController.value = 1;
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleToggle() {
    // Toggle the theme first
    Managers.themeStateStore.toggleThemeMode();

    // Then animate to show the new "what would switch to" state
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final iconColor = widget.color ?? Theme.of(context).colorScheme.onSurface;

        return InkWell(
          onTap: _handleToggle,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Icon(
                  _animationController.value < 0.5 ? Icons.wb_sunny : Icons.nightlight_round,
                  size: widget.size,
                  color: iconColor,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
