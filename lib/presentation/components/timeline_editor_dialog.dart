import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/data/models/timeline_model.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

/// Dialog for creating or editing an experience / education entry.
class TimelineEditorDialog extends StatefulWidget {
  /// [TimelineEditorDialog] constructor.
  const TimelineEditorDialog({
    super.key,
    required this.isEducation,
    this.initial,
  });

  /// Whether this entry belongs to education rather than experience.
  final bool isEducation;

  /// Existing entry when editing.
  final TimelineModel? initial;

  /// Opens the editor and returns a [TimelineModel] on save.
  static Future<TimelineModel?> show(
    BuildContext context, {
    required bool isEducation,
    TimelineModel? initial,
  }) {
    return showDialog<TimelineModel>(
      context: context,
      useRootNavigator: false,
      builder: (context) => TimelineEditorDialog(isEducation: isEducation, initial: initial),
    );
  }

  @override
  State<TimelineEditorDialog> createState() => _TimelineEditorDialogState();
}

class _TimelineEditorDialogState extends State<TimelineEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _organization;
  late final TextEditingController _location;
  late final TextEditingController _description;
  late final TextEditingController _dateLabel;
  DateTime? _startDate;
  DateTime? _endDate;
  late bool _isCurrent;

  bool get _isEducation => widget.isEducation;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _title = TextEditingController(text: initial?.title ?? "");
    _organization = TextEditingController(text: initial?.organization ?? "");
    _location = TextEditingController(text: initial?.location ?? "");
    _description = TextEditingController(text: initial?.description ?? "");
    _dateLabel = TextEditingController(text: initial?.dateLabel ?? "");
    _startDate = initial?.startDate;
    _endDate = initial?.endDate;
    _isCurrent = initial?.isCurrent ?? false;
  }

  @override
  void dispose() {
    _title.dispose();
    _organization.dispose();
    _location.dispose();
    _description.dispose();
    _dateLabel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final titleLabel = _isEducation ? "Course / qualification" : "Role / company";
    final orgLabel = _isEducation ? "Institution" : "Organization";
    return AlertDialog(
      title: Text(widget.initial == null ? (_isEducation ? "Add education" : "Add experience") : (_isEducation ? "Edit education" : "Edit experience")),
      actionsPadding: EdgeInsets.all(tokens.spacing.md),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _title,
                  decoration: InputDecoration(labelText: titleLabel),
                  textCapitalization: TextCapitalization.sentences,
                  validator: _required,
                ),
                SizedBox(height: tokens.spacing.md),
                TextFormField(
                  controller: _organization,
                  decoration: InputDecoration(labelText: orgLabel),
                  textCapitalization: TextCapitalization.sentences,
                  validator: _required,
                ),
                SizedBox(height: tokens.spacing.md),
                TextFormField(
                  controller: _location,
                  decoration: const InputDecoration(labelText: "Location (optional)"),
                ),
                SizedBox(height: tokens.spacing.md),
                TextFormField(
                  controller: _description,
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 4,
                ),
                SizedBox(height: tokens.spacing.md),
                TextFormField(
                  controller: _dateLabel,
                  decoration: const InputDecoration(
                    labelText: "Date label override (optional)",
                    hintText: "Planned · 11/2025",
                  ),
                ),
                SizedBox(height: tokens.spacing.md),
                Row(
                  children: [
                    Expanded(child: _dateButton(context, label: "Start", value: _startDate, onPicked: (date) => setState(() => _startDate = date))),
                    SizedBox(width: tokens.spacing.sm),
                    Expanded(
                      child: _dateButton(
                        context,
                        label: "End",
                        value: _endDate,
                        enabled: !_isCurrent,
                        onPicked: (date) => setState(() => _endDate = date),
                      ),
                    ),
                  ],
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _isCurrent,
                  onChanged: (value) => setState(() {
                    _isCurrent = value ?? false;
                    if (_isCurrent) {
                      _endDate = null;
                    }
                  }),
                  title: Text(_isEducation ? "In progress" : "Current role"),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel")),
        FilledButton(onPressed: _submit, child: const Text("Save")),
      ],
    );
  }

  Widget _dateButton(
    BuildContext context, {
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime> onPicked,
    bool enabled = true,
  }) {
    final formatter = DateFormat("MM/yyyy");
    return OutlinedButton(
      onPressed: enabled
          ? () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: value ?? now,
                firstDate: DateTime(1990),
                lastDate: DateTime(now.year + 6),
                helpText: "$label date",
              );
              if (picked != null) {
                onPicked(DateTime(picked.year, picked.month));
              }
            }
          : null,
      child: Text(value == null ? label : "$label ${formatter.format(value)}"),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Required";
    }
    return null;
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final title = _title.text.trim();
    final organization = _organization.text.trim();
    final dateLabel = _dateLabel.text.trim();
    Navigator.of(context).pop(
      TimelineModel(
        id: widget.initial?.id ?? _idFromTitle(title),
        title: title,
        organization: organization,
        location: _blankToNull(_location.text),
        description: _blankToNull(_description.text),
        dateLabel: dateLabel.isEmpty ? null : dateLabel,
        startDate: _startDate,
        endDate: _isCurrent ? null : _endDate,
      ),
    );
  }

  String _idFromTitle(String title) {
    final slug = title.toLowerCase().replaceAll(RegExp("[^a-z0-9]+"), "-").replaceAll(RegExp(r"^-+|-+$"), "");
    if (slug.isEmpty) {
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
    return slug;
  }

  String? _blankToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
