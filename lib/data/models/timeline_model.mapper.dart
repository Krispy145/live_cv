// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'timeline_model.dart';

class TimelineModelMapper extends ClassMapperBase<TimelineModel> {
  TimelineModelMapper._();

  static TimelineModelMapper? _instance;
  static TimelineModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TimelineModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TimelineModel';

  static String _$id(TimelineModel v) => v.id;
  static const Field<TimelineModel, String> _f$id = Field('id', _$id);
  static String _$title(TimelineModel v) => v.title;
  static const Field<TimelineModel, String> _f$title = Field('title', _$title);
  static String _$organization(TimelineModel v) => v.organization;
  static const Field<TimelineModel, String> _f$organization = Field(
    'organization',
    _$organization,
  );
  static DateTime? _$startDate(TimelineModel v) => v.startDate;
  static const Field<TimelineModel, DateTime> _f$startDate = Field(
    'startDate',
    _$startDate,
    key: r'start_date',
    opt: true,
  );
  static DateTime? _$endDate(TimelineModel v) => v.endDate;
  static const Field<TimelineModel, DateTime> _f$endDate = Field(
    'endDate',
    _$endDate,
    key: r'end_date',
    opt: true,
  );
  static String? _$dateLabel(TimelineModel v) => v.dateLabel;
  static const Field<TimelineModel, String> _f$dateLabel = Field(
    'dateLabel',
    _$dateLabel,
    key: r'date_label',
    opt: true,
  );
  static String? _$location(TimelineModel v) => v.location;
  static const Field<TimelineModel, String> _f$location = Field(
    'location',
    _$location,
    opt: true,
  );
  static String? _$description(TimelineModel v) => v.description;
  static const Field<TimelineModel, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );
  static List<String> _$highlights(TimelineModel v) => v.highlights;
  static const Field<TimelineModel, List<String>> _f$highlights = Field(
    'highlights',
    _$highlights,
    opt: true,
    def: const [],
  );
  static List<String> _$skills(TimelineModel v) => v.skills;
  static const Field<TimelineModel, List<String>> _f$skills = Field(
    'skills',
    _$skills,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<TimelineModel> fields = const {
    #id: _f$id,
    #title: _f$title,
    #organization: _f$organization,
    #startDate: _f$startDate,
    #endDate: _f$endDate,
    #dateLabel: _f$dateLabel,
    #location: _f$location,
    #description: _f$description,
    #highlights: _f$highlights,
    #skills: _f$skills,
  };
  @override
  final bool ignoreNull = true;

  static TimelineModel _instantiate(DecodingData data) {
    return TimelineModel(
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      organization: data.dec(_f$organization),
      startDate: data.dec(_f$startDate),
      endDate: data.dec(_f$endDate),
      dateLabel: data.dec(_f$dateLabel),
      location: data.dec(_f$location),
      description: data.dec(_f$description),
      highlights: data.dec(_f$highlights),
      skills: data.dec(_f$skills),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TimelineModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TimelineModel>(map);
  }

  static TimelineModel fromJson(String json) {
    return ensureInitialized().decodeJson<TimelineModel>(json);
  }
}

mixin TimelineModelMappable {
  String toJson() {
    return TimelineModelMapper.ensureInitialized().encodeJson<TimelineModel>(
      this as TimelineModel,
    );
  }

  Map<String, dynamic> toMap() {
    return TimelineModelMapper.ensureInitialized().encodeMap<TimelineModel>(
      this as TimelineModel,
    );
  }

  TimelineModelCopyWith<TimelineModel, TimelineModel, TimelineModel>
  get copyWith => _TimelineModelCopyWithImpl<TimelineModel, TimelineModel>(
    this as TimelineModel,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return TimelineModelMapper.ensureInitialized().stringifyValue(
      this as TimelineModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return TimelineModelMapper.ensureInitialized().equalsValue(
      this as TimelineModel,
      other,
    );
  }

  @override
  int get hashCode {
    return TimelineModelMapper.ensureInitialized().hashValue(
      this as TimelineModel,
    );
  }
}

extension TimelineModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TimelineModel, $Out> {
  TimelineModelCopyWith<$R, TimelineModel, $Out> get $asTimelineModel =>
      $base.as((v, t, t2) => _TimelineModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TimelineModelCopyWith<$R, $In extends TimelineModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get highlights;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get skills;
  $R call({
    String? id,
    String? title,
    String? organization,
    DateTime? startDate,
    DateTime? endDate,
    String? dateLabel,
    String? location,
    String? description,
    List<String>? highlights,
    List<String>? skills,
  });
  TimelineModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TimelineModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TimelineModel, $Out>
    implements TimelineModelCopyWith<$R, TimelineModel, $Out> {
  _TimelineModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TimelineModel> $mapper =
      TimelineModelMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get highlights =>
      ListCopyWith(
        $value.highlights,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(highlights: v),
      );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get skills =>
      ListCopyWith(
        $value.skills,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(skills: v),
      );
  @override
  $R call({
    String? id,
    String? title,
    String? organization,
    Object? startDate = $none,
    Object? endDate = $none,
    Object? dateLabel = $none,
    Object? location = $none,
    Object? description = $none,
    List<String>? highlights,
    List<String>? skills,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (title != null) #title: title,
      if (organization != null) #organization: organization,
      if (startDate != $none) #startDate: startDate,
      if (endDate != $none) #endDate: endDate,
      if (dateLabel != $none) #dateLabel: dateLabel,
      if (location != $none) #location: location,
      if (description != $none) #description: description,
      if (highlights != null) #highlights: highlights,
      if (skills != null) #skills: skills,
    }),
  );
  @override
  TimelineModel $make(CopyWithData data) => TimelineModel(
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    organization: data.get(#organization, or: $value.organization),
    startDate: data.get(#startDate, or: $value.startDate),
    endDate: data.get(#endDate, or: $value.endDate),
    dateLabel: data.get(#dateLabel, or: $value.dateLabel),
    location: data.get(#location, or: $value.location),
    description: data.get(#description, or: $value.description),
    highlights: data.get(#highlights, or: $value.highlights),
    skills: data.get(#skills, or: $value.skills),
  );

  @override
  TimelineModelCopyWith<$R2, TimelineModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TimelineModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

