// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'roadmap_summary.dart';

class RoadmapSummaryMapper extends ClassMapperBase<RoadmapSummary> {
  RoadmapSummaryMapper._();

  static RoadmapSummaryMapper? _instance;
  static RoadmapSummaryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RoadmapSummaryMapper._());
      RoadmapMilestoneMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'RoadmapSummary';

  static DateTime _$updated(RoadmapSummary v) => v.updated;
  static const Field<RoadmapSummary, DateTime> _f$updated =
      Field('updated', _$updated);
  static String? _$current(RoadmapSummary v) => v.current;
  static const Field<RoadmapSummary, String> _f$current =
      Field('current', _$current, opt: true);
  static String? _$next(RoadmapSummary v) => v.next;
  static const Field<RoadmapSummary, String> _f$next =
      Field('next', _$next, opt: true);
  static String? _$then_(RoadmapSummary v) => v.then_;
  static const Field<RoadmapSummary, String> _f$then_ =
      Field('then_', _$then_, opt: true);
  static DateTime? _$securityPrepStart(RoadmapSummary v) => v.securityPrepStart;
  static const Field<RoadmapSummary, DateTime> _f$securityPrepStart =
      Field('securityPrepStart', _$securityPrepStart, opt: true);
  static int _$learning(RoadmapSummary v) => v.learning;
  static const Field<RoadmapSummary, int> _f$learning =
      Field('learning', _$learning, opt: true, def: 0);
  static int _$projects(RoadmapSummary v) => v.projects;
  static const Field<RoadmapSummary, int> _f$projects =
      Field('projects', _$projects, opt: true, def: 0);
  static int _$backend(RoadmapSummary v) => v.backend;
  static const Field<RoadmapSummary, int> _f$backend =
      Field('backend', _$backend, opt: true, def: 0);
  static int _$flutter(RoadmapSummary v) => v.flutter;
  static const Field<RoadmapSummary, int> _f$flutter =
      Field('flutter', _$flutter, opt: true, def: 0);
  static int _$certifications(RoadmapSummary v) => v.certifications;
  static const Field<RoadmapSummary, int> _f$certifications =
      Field('certifications', _$certifications, opt: true, def: 0);
  static String _$repoUrl(RoadmapSummary v) => v.repoUrl;
  static const Field<RoadmapSummary, String> _f$repoUrl =
      Field('repoUrl', _$repoUrl);
  static String _$readmeUrl(RoadmapSummary v) => v.readmeUrl;
  static const Field<RoadmapSummary, String> _f$readmeUrl =
      Field('readmeUrl', _$readmeUrl);
  static RoadmapMilestone? _$nextMilestone(RoadmapSummary v) => v.nextMilestone;
  static const Field<RoadmapSummary, RoadmapMilestone> _f$nextMilestone =
      Field('nextMilestone', _$nextMilestone, opt: true);

  @override
  final MappableFields<RoadmapSummary> fields = const {
    #updated: _f$updated,
    #current: _f$current,
    #next: _f$next,
    #then_: _f$then_,
    #securityPrepStart: _f$securityPrepStart,
    #learning: _f$learning,
    #projects: _f$projects,
    #backend: _f$backend,
    #flutter: _f$flutter,
    #certifications: _f$certifications,
    #repoUrl: _f$repoUrl,
    #readmeUrl: _f$readmeUrl,
    #nextMilestone: _f$nextMilestone,
  };

  static RoadmapSummary _instantiate(DecodingData data) {
    return RoadmapSummary(
        updated: data.dec(_f$updated),
        current: data.dec(_f$current),
        next: data.dec(_f$next),
        then_: data.dec(_f$then_),
        securityPrepStart: data.dec(_f$securityPrepStart),
        learning: data.dec(_f$learning),
        projects: data.dec(_f$projects),
        backend: data.dec(_f$backend),
        flutter: data.dec(_f$flutter),
        certifications: data.dec(_f$certifications),
        repoUrl: data.dec(_f$repoUrl),
        readmeUrl: data.dec(_f$readmeUrl),
        nextMilestone: data.dec(_f$nextMilestone));
  }

  @override
  final Function instantiate = _instantiate;

  static RoadmapSummary fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RoadmapSummary>(map);
  }

  static RoadmapSummary fromJson(String json) {
    return ensureInitialized().decodeJson<RoadmapSummary>(json);
  }
}

mixin RoadmapSummaryMappable {
  String toJson() {
    return RoadmapSummaryMapper.ensureInitialized()
        .encodeJson<RoadmapSummary>(this as RoadmapSummary);
  }

  Map<String, dynamic> toMap() {
    return RoadmapSummaryMapper.ensureInitialized()
        .encodeMap<RoadmapSummary>(this as RoadmapSummary);
  }

  RoadmapSummaryCopyWith<RoadmapSummary, RoadmapSummary, RoadmapSummary>
      get copyWith =>
          _RoadmapSummaryCopyWithImpl<RoadmapSummary, RoadmapSummary>(
              this as RoadmapSummary, $identity, $identity);
  @override
  String toString() {
    return RoadmapSummaryMapper.ensureInitialized()
        .stringifyValue(this as RoadmapSummary);
  }

  @override
  bool operator ==(Object other) {
    return RoadmapSummaryMapper.ensureInitialized()
        .equalsValue(this as RoadmapSummary, other);
  }

  @override
  int get hashCode {
    return RoadmapSummaryMapper.ensureInitialized()
        .hashValue(this as RoadmapSummary);
  }
}

extension RoadmapSummaryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RoadmapSummary, $Out> {
  RoadmapSummaryCopyWith<$R, RoadmapSummary, $Out> get $asRoadmapSummary =>
      $base.as((v, t, t2) => _RoadmapSummaryCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RoadmapSummaryCopyWith<$R, $In extends RoadmapSummary, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  RoadmapMilestoneCopyWith<$R, RoadmapMilestone, RoadmapMilestone>?
      get nextMilestone;
  $R call(
      {DateTime? updated,
      String? current,
      String? next,
      String? then_,
      DateTime? securityPrepStart,
      int? learning,
      int? projects,
      int? backend,
      int? flutter,
      int? certifications,
      String? repoUrl,
      String? readmeUrl,
      RoadmapMilestone? nextMilestone});
  RoadmapSummaryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _RoadmapSummaryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RoadmapSummary, $Out>
    implements RoadmapSummaryCopyWith<$R, RoadmapSummary, $Out> {
  _RoadmapSummaryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RoadmapSummary> $mapper =
      RoadmapSummaryMapper.ensureInitialized();
  @override
  RoadmapMilestoneCopyWith<$R, RoadmapMilestone, RoadmapMilestone>?
      get nextMilestone =>
          $value.nextMilestone?.copyWith.$chain((v) => call(nextMilestone: v));
  @override
  $R call(
          {DateTime? updated,
          Object? current = $none,
          Object? next = $none,
          Object? then_ = $none,
          Object? securityPrepStart = $none,
          int? learning,
          int? projects,
          int? backend,
          int? flutter,
          int? certifications,
          String? repoUrl,
          String? readmeUrl,
          Object? nextMilestone = $none}) =>
      $apply(FieldCopyWithData({
        if (updated != null) #updated: updated,
        if (current != $none) #current: current,
        if (next != $none) #next: next,
        if (then_ != $none) #then_: then_,
        if (securityPrepStart != $none) #securityPrepStart: securityPrepStart,
        if (learning != null) #learning: learning,
        if (projects != null) #projects: projects,
        if (backend != null) #backend: backend,
        if (flutter != null) #flutter: flutter,
        if (certifications != null) #certifications: certifications,
        if (repoUrl != null) #repoUrl: repoUrl,
        if (readmeUrl != null) #readmeUrl: readmeUrl,
        if (nextMilestone != $none) #nextMilestone: nextMilestone
      }));
  @override
  RoadmapSummary $make(CopyWithData data) => RoadmapSummary(
      updated: data.get(#updated, or: $value.updated),
      current: data.get(#current, or: $value.current),
      next: data.get(#next, or: $value.next),
      then_: data.get(#then_, or: $value.then_),
      securityPrepStart:
          data.get(#securityPrepStart, or: $value.securityPrepStart),
      learning: data.get(#learning, or: $value.learning),
      projects: data.get(#projects, or: $value.projects),
      backend: data.get(#backend, or: $value.backend),
      flutter: data.get(#flutter, or: $value.flutter),
      certifications: data.get(#certifications, or: $value.certifications),
      repoUrl: data.get(#repoUrl, or: $value.repoUrl),
      readmeUrl: data.get(#readmeUrl, or: $value.readmeUrl),
      nextMilestone: data.get(#nextMilestone, or: $value.nextMilestone));

  @override
  RoadmapSummaryCopyWith<$R2, RoadmapSummary, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _RoadmapSummaryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class RoadmapMilestoneMapper extends ClassMapperBase<RoadmapMilestone> {
  RoadmapMilestoneMapper._();

  static RoadmapMilestoneMapper? _instance;
  static RoadmapMilestoneMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RoadmapMilestoneMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RoadmapMilestone';

  static String _$title(RoadmapMilestone v) => v.title;
  static const Field<RoadmapMilestone, String> _f$title =
      Field('title', _$title);
  static DateTime? _$due(RoadmapMilestone v) => v.due;
  static const Field<RoadmapMilestone, DateTime> _f$due =
      Field('due', _$due, opt: true);

  @override
  final MappableFields<RoadmapMilestone> fields = const {
    #title: _f$title,
    #due: _f$due,
  };

  static RoadmapMilestone _instantiate(DecodingData data) {
    return RoadmapMilestone(title: data.dec(_f$title), due: data.dec(_f$due));
  }

  @override
  final Function instantiate = _instantiate;

  static RoadmapMilestone fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RoadmapMilestone>(map);
  }

  static RoadmapMilestone fromJson(String json) {
    return ensureInitialized().decodeJson<RoadmapMilestone>(json);
  }
}

mixin RoadmapMilestoneMappable {
  String toJson() {
    return RoadmapMilestoneMapper.ensureInitialized()
        .encodeJson<RoadmapMilestone>(this as RoadmapMilestone);
  }

  Map<String, dynamic> toMap() {
    return RoadmapMilestoneMapper.ensureInitialized()
        .encodeMap<RoadmapMilestone>(this as RoadmapMilestone);
  }

  RoadmapMilestoneCopyWith<RoadmapMilestone, RoadmapMilestone, RoadmapMilestone>
      get copyWith =>
          _RoadmapMilestoneCopyWithImpl<RoadmapMilestone, RoadmapMilestone>(
              this as RoadmapMilestone, $identity, $identity);
  @override
  String toString() {
    return RoadmapMilestoneMapper.ensureInitialized()
        .stringifyValue(this as RoadmapMilestone);
  }

  @override
  bool operator ==(Object other) {
    return RoadmapMilestoneMapper.ensureInitialized()
        .equalsValue(this as RoadmapMilestone, other);
  }

  @override
  int get hashCode {
    return RoadmapMilestoneMapper.ensureInitialized()
        .hashValue(this as RoadmapMilestone);
  }
}

extension RoadmapMilestoneValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RoadmapMilestone, $Out> {
  RoadmapMilestoneCopyWith<$R, RoadmapMilestone, $Out>
      get $asRoadmapMilestone => $base
          .as((v, t, t2) => _RoadmapMilestoneCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RoadmapMilestoneCopyWith<$R, $In extends RoadmapMilestone, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? title, DateTime? due});
  RoadmapMilestoneCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _RoadmapMilestoneCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RoadmapMilestone, $Out>
    implements RoadmapMilestoneCopyWith<$R, RoadmapMilestone, $Out> {
  _RoadmapMilestoneCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RoadmapMilestone> $mapper =
      RoadmapMilestoneMapper.ensureInitialized();
  @override
  $R call({String? title, Object? due = $none}) => $apply(FieldCopyWithData(
      {if (title != null) #title: title, if (due != $none) #due: due}));
  @override
  RoadmapMilestone $make(CopyWithData data) => RoadmapMilestone(
      title: data.get(#title, or: $value.title),
      due: data.get(#due, or: $value.due));

  @override
  RoadmapMilestoneCopyWith<$R2, RoadmapMilestone, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _RoadmapMilestoneCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
