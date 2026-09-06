import "package:auto_route/auto_route.dart";
import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/data/showcase/showcase_catalog.dart";
import "package:cv_app/domain/showcase/showcase_models.dart";
import "package:cv_app/navigation/routes.gr.dart";
import "package:cv_app/presentation/work/components/showcase_page.dart";
import "package:flutter/material.dart";

/// Stack grouped by layer, each technology linking to case studies.
@RoutePage()
class EngineeringView extends StatefulWidget {
  /// [EngineeringView] constructor.
  const EngineeringView({super.key});

  @override
  State<EngineeringView> createState() => _EngineeringViewState();
}

class _EngineeringViewState extends State<EngineeringView> {
  String? _selectedTech;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final groups = ShowcaseCatalog.stackGroups;
    final selected = _selectedTech;
    final matches = selected == null ? const <CaseStudy>[] : ShowcaseCatalog.featured.where((study) => study.stack.contains(selected)).toList();

    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        child: ShowcasePage(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Engineering",
                style: tokens.text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: tokens.spacing.sm),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Text(
                  "Technologies I have actually used, grouped by layer. Choose one to see the case studies that used it.",
                  style: tokens.text.bodyLarge?.copyWith(
                    color: tokens.color.onSurfaceWithOpacity(0.7),
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: tokens.spacing.xxl),
              _StackFilterBar(
                groups: groups,
                selectedTech: selected,
                onSelected: (tech) => setState(() => _selectedTech = tech),
              ),
              if (selected != null) ...[
                const ShowcaseRule(),
                Text(
                  "Used in ${matches.length} project${matches.length == 1 ? "" : "s"}",
                  style: tokens.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: tokens.spacing.md),
                ...matches.map(
                  (study) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    mouseCursor: SystemMouseCursors.click,
                    title: Text(study.title),
                    subtitle: Text(study.subtitle),
                    trailing: const Icon(Icons.arrow_forward, size: 16),
                    onTap: () => context.router.push(CaseStudyRoute(slug: study.slug)),
                  ),
                ),
              ],
              const ShowcaseRule(),
              TextButton(
                onPressed: () => context.router.navigate(const ProjectsRoute()),
                style: TextButton.styleFrom(
                  overlayColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                ),
                child: const Text("Other work on GitHub  →"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Editorial Material 3 filter bar, one menu per stack layer.
class _StackFilterBar extends StatelessWidget {
  const _StackFilterBar({
    required this.groups,
    required this.selectedTech,
    required this.onSelected,
  });

  final List<(String, List<EngineeringTech>)> groups;
  final String? selectedTech;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 720;
            if (compact) {
              final gap = tokens.spacing.md;
              final columns = constraints.maxWidth >= 420 ? 2 : 1;
              final itemWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final group in groups)
                    SizedBox(
                      width: itemWidth,
                      child: _FilterSurface(
                        child: _LayerMenu(
                          group: group,
                          selectedTech: selectedTech,
                          onSelected: onSelected,
                        ),
                      ),
                    ),
                ],
              );
            }

            return _FilterSurface(
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var index = 0; index < groups.length; index++) ...[
                      if (index > 0)
                        VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: scheme.outline.withValues(alpha: 0.1),
                        ),
                      Expanded(
                        child: _LayerMenu(
                          group: groups[index],
                          selectedTech: selectedTech,
                          onSelected: onSelected,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
        if (selectedTech != null) ...[
          SizedBox(height: tokens.spacing.lg),
          Row(
            children: [
              Text(
                "Filtered by  ",
                style: tokens.text.bodyMedium?.copyWith(
                  color: tokens.color.onSurfaceWithOpacity(0.55),
                ),
              ),
              Text(
                selectedTech!,
                style: tokens.text.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => onSelected(null),
                style: TextButton.styleFrom(
                  overlayColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                ),
                child: const Text("Clear"),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _FilterSurface extends StatelessWidget {
  const _FilterSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.06),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: child,
      ),
    );
  }
}

class _LayerMenu extends StatelessWidget {
  const _LayerMenu({
    required this.group,
    required this.selectedTech,
    required this.onSelected,
  });

  final (String, List<EngineeringTech>) group;
  final String? selectedTech;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final category = group.$1;
    final techs = group.$2;
    final active = techs.any((tech) => tech.name == selectedTech);
    final value = active ? selectedTech! : "Any";

    return MenuAnchor(
      consumeOutsideTap: true,
      alignmentOffset: const Offset(12, 6),
      style: MenuStyle(
        elevation: const WidgetStatePropertyAll(8),
        shadowColor: WidgetStatePropertyAll(
          scheme.shadow.withValues(alpha: 0.16),
        ),
        backgroundColor: WidgetStatePropertyAll(scheme.surface),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 8)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: scheme.outline.withValues(alpha: 0.1)),
          ),
        ),
      ),
      builder: (context, controller, _) {
        return _LayerTrigger(
          category: category,
          value: value,
          active: active,
          isOpen: controller.isOpen,
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
      menuChildren: [
        _LayerMenuItem(
          label: "Any",
          selected: !active,
          onPressed: () => onSelected(null),
        ),
        for (final tech in techs)
          _LayerMenuItem(
            label: tech.name,
            detail: "${tech.caseStudySlugs.length}",
            selected: selectedTech == tech.name,
            onPressed: () => onSelected(tech.name),
          ),
      ],
    );
  }
}

class _LayerTrigger extends StatelessWidget {
  const _LayerTrigger({
    required this.category,
    required this.value,
    required this.active,
    required this.isOpen,
    required this.onPressed,
  });

  final String category;
  final String value;
  final bool active;
  final bool isOpen;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final muted = tokens.color.onSurfaceWithOpacity(0.48);

    return Material(
      color: active ? scheme.primary.withValues(alpha: 0.05) : Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 2,
                color: active || isOpen ? scheme.primary : Colors.transparent,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(_layerIcon(category), size: 14, color: muted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      category.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.text.bodySmall?.copyWith(
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.w700,
                        color: muted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: active ? scheme.primary : scheme.onSurface,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 22,
                      color: tokens.color.onSurfaceWithOpacity(0.45),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LayerMenuItem extends StatelessWidget {
  const _LayerMenuItem({
    required this.label,
    required this.selected,
    required this.onPressed,
    this.detail,
  });

  final String label;
  final String? detail;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final scheme = Theme.of(context).colorScheme;

    return MenuItemButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          selected ? scheme.secondaryContainer.withValues(alpha: 0.7) : null,
        ),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
      trailingIcon: selected
          ? Icon(Icons.check, size: 18, color: scheme.primary)
          : detail == null
              ? null
              : Text(
                  detail!,
                  style: tokens.text.bodySmall?.copyWith(
                    color: tokens.color.onSurfaceWithOpacity(0.4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
      child: Text(
        label,
        style: tokens.text.bodyMedium?.copyWith(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}

IconData _layerIcon(String category) {
  return switch (category) {
    "Application" => Icons.devices_outlined,
    "Backend" => Icons.dns_outlined,
    "Cloud" => Icons.cloud_outlined,
    "Data" => Icons.storage_outlined,
    "Infrastructure" => Icons.settings_outlined,
    _ => Icons.category_outlined,
  };
}
