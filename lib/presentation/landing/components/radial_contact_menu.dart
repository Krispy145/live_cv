import "dart:math" as math;

import "package:cv_app/core/theme/theme_tokens.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

enum ContactType {
  email,
  phone,
  github,
  linkedin,
  location,
}

class RadialContactMenu extends StatefulWidget {
  final void Function(ContactType) onContactSelected;

  const RadialContactMenu({
    super.key,
    required this.onContactSelected,
  });

  @override
  State<RadialContactMenu> createState() => _RadialContactMenuState();
}

class _RadialContactMenuState extends State<RadialContactMenu> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  bool _isExpanded = false;

  final List<ContactItem> _contactItems = [
    ContactItem(
      type: ContactType.email,
      icon: FontAwesomeIcons.envelope,
      label: "Email",
      color: Colors.red,
    ),
    ContactItem(
      type: ContactType.phone,
      icon: FontAwesomeIcons.phone,
      label: "Phone",
      color: Colors.green,
    ),
    ContactItem(
      type: ContactType.github,
      icon: FontAwesomeIcons.github,
      label: "GitHub",
      color: Colors.black,
    ),
    ContactItem(
      type: ContactType.linkedin,
      icon: FontAwesomeIcons.linkedin,
      label: "LinkedIn",
      color: Colors.blue,
    ),
    ContactItem(
      type: ContactType.location,
      icon: FontAwesomeIcons.locationDot,
      label: "Location",
      color: Colors.orange,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInCirc,
      ),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInCirc,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);

    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // Radial menu items - positioned in bottom-right quarter circle
          ...List.generate(_contactItems.length, (index) {
            final item = _contactItems[index];
            // Start from -π (left) and go to -π/2 (up) for bottom-right quarter
            // Use 90 degrees with larger radius for better spacing
            const totalAngle = math.pi / 2; // 90 degrees
            const startAngle = -math.pi; // Start from left
            final angle = startAngle + (index * totalAngle / math.max(1, _contactItems.length - 1));
            const radius = 140.0;

            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final progress = _scaleAnimation.value;
                final rotation = _rotationAnimation.value;

                final x = math.cos(angle + rotation * 0.1) * radius * progress;
                final y = math.sin(angle + rotation * 0.1) * radius * progress;

                return Transform.translate(
                  offset: Offset(x, y),
                  child: Transform.scale(
                    scale: progress,
                    child: _RadialMenuItem(
                      item: item,
                      onTap: () {
                        widget.onContactSelected(item.type);
                        _toggleMenu();
                      },
                    ),
                  ),
                );
              },
            );
          }),

          // Main floating action button
          AnimatedPhysicalModel(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            shape: BoxShape.circle,
            elevation: _isExpanded ? 12 : 6,
            color: tokens.color.primary,
            shadowColor: Colors.black,
            child: SizedBox(
              width: 56,
              height: 56,
              child: Material(
                type: MaterialType.transparency,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: _toggleMenu,
                  customBorder: const CircleBorder(),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _CenteredFaIcon(
                        key: ValueKey(_isExpanded),
                        icon: _isExpanded ? FontAwesomeIcons.xmark : FontAwesomeIcons.envelope,
                        color: tokens.color.onPrimary,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Font Awesome 11's [FaIcon] is a raw glyph (no square / [Center]), so it
/// sits at the top-left of a sized circle unless it is boxed and centered.
class _CenteredFaIcon extends StatelessWidget {
  const _CenteredFaIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.size,
  });

  final FaIconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: FaIcon(icon, color: color, size: size),
      ),
    );
  }
}

class ContactItem {
  final ContactType type;
  final FaIconData icon;
  final String label;
  final Color color;

  ContactItem({
    required this.type,
    required this.icon,
    required this.label,
    required this.color,
  });
}

class _RadialMenuItem extends StatefulWidget {
  final ContactItem item;
  final VoidCallback onTap;

  const _RadialMenuItem({
    required this.item,
    required this.onTap,
  });

  @override
  State<_RadialMenuItem> createState() => _RadialMenuItemState();
}

class _RadialMenuItemState extends State<_RadialMenuItem> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _hoverController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) {
          if (mounted) {
            setState(() => _isHovered = true);
            _hoverController.forward();
          }
        },
        onExit: (_) {
          if (mounted) {
            setState(() => _isHovered = false);
            _hoverController.reverse();
          }
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: _isHovered ? 120 : 48,
                height: 48,
                alignment: Alignment.center,
                padding: _isHovered ? const EdgeInsets.symmetric(horizontal: 12) : EdgeInsets.zero,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: widget.item.color.withValues(alpha: 0.9),
                  boxShadow: [
                    BoxShadow(
                      color: widget.item.color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isHovered) ...[
                      Flexible(
                        child: Text(
                          widget.item.label,
                          style: tokens.text.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    _CenteredFaIcon(
                      icon: widget.item.icon,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
