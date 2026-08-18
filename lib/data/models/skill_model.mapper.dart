// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'skill_model.dart';

class SkillProficiencyMapper extends EnumMapper<SkillProficiency> {
  SkillProficiencyMapper._();

  static SkillProficiencyMapper? _instance;
  static SkillProficiencyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SkillProficiencyMapper._());
    }
    return _instance!;
  }

  static SkillProficiency fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  SkillProficiency decode(dynamic value) {
    switch (value) {
      case r'exploring':
        return SkillProficiency.exploring;
      case r'developing':
        return SkillProficiency.developing;
      case r'proficient':
        return SkillProficiency.proficient;
      case r'specialized':
        return SkillProficiency.specialized;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(SkillProficiency self) {
    switch (self) {
      case SkillProficiency.exploring:
        return r'exploring';
      case SkillProficiency.developing:
        return r'developing';
      case SkillProficiency.proficient:
        return r'proficient';
      case SkillProficiency.specialized:
        return r'specialized';
    }
  }
}

extension SkillProficiencyMapperExtension on SkillProficiency {
  String toValue() {
    SkillProficiencyMapper.ensureInitialized();
    return MapperContainer.globals.toValue<SkillProficiency>(this) as String;
  }
}

class SkillModelMapper extends ClassMapperBase<SkillModel> {
  SkillModelMapper._();

  static SkillModelMapper? _instance;
  static SkillModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SkillModelMapper._());
      SkillProficiencyMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SkillModel';

  static String _$name(SkillModel v) => v.name;
  static const Field<SkillModel, String> _f$name = Field('name', _$name);
  static String? _$category(SkillModel v) => v.category;
  static const Field<SkillModel, String> _f$category = Field(
    'category',
    _$category,
    opt: true,
  );
  static SkillProficiency _$proficiency(SkillModel v) => v.proficiency;
  static const Field<SkillModel, SkillProficiency> _f$proficiency = Field(
    'proficiency',
    _$proficiency,
    opt: true,
    def: SkillProficiency.developing,
  );

  @override
  final MappableFields<SkillModel> fields = const {
    #name: _f$name,
    #category: _f$category,
    #proficiency: _f$proficiency,
  };
  @override
  final bool ignoreNull = true;

  static SkillModel _instantiate(DecodingData data) {
    return SkillModel(
      name: data.dec(_f$name),
      category: data.dec(_f$category),
      proficiency: data.dec(_f$proficiency),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SkillModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SkillModel>(map);
  }

  static SkillModel fromJson(String json) {
    return ensureInitialized().decodeJson<SkillModel>(json);
  }
}

mixin SkillModelMappable {
  String toJson() {
    return SkillModelMapper.ensureInitialized().encodeJson<SkillModel>(
      this as SkillModel,
    );
  }

  Map<String, dynamic> toMap() {
    return SkillModelMapper.ensureInitialized().encodeMap<SkillModel>(
      this as SkillModel,
    );
  }

  SkillModelCopyWith<SkillModel, SkillModel, SkillModel> get copyWith =>
      _SkillModelCopyWithImpl<SkillModel, SkillModel>(
        this as SkillModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SkillModelMapper.ensureInitialized().stringifyValue(
      this as SkillModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return SkillModelMapper.ensureInitialized().equalsValue(
      this as SkillModel,
      other,
    );
  }

  @override
  int get hashCode {
    return SkillModelMapper.ensureInitialized().hashValue(this as SkillModel);
  }
}

extension SkillModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SkillModel, $Out> {
  SkillModelCopyWith<$R, SkillModel, $Out> get $asSkillModel =>
      $base.as((v, t, t2) => _SkillModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SkillModelCopyWith<$R, $In extends SkillModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, String? category, SkillProficiency? proficiency});
  SkillModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SkillModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SkillModel, $Out>
    implements SkillModelCopyWith<$R, SkillModel, $Out> {
  _SkillModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SkillModel> $mapper =
      SkillModelMapper.ensureInitialized();
  @override
  $R call({
    String? name,
    Object? category = $none,
    SkillProficiency? proficiency,
  }) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (category != $none) #category: category,
      if (proficiency != null) #proficiency: proficiency,
    }),
  );
  @override
  SkillModel $make(CopyWithData data) => SkillModel(
    name: data.get(#name, or: $value.name),
    category: data.get(#category, or: $value.category),
    proficiency: data.get(#proficiency, or: $value.proficiency),
  );

  @override
  SkillModelCopyWith<$R2, SkillModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SkillModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SkillGroupModelMapper extends ClassMapperBase<SkillGroupModel> {
  SkillGroupModelMapper._();

  static SkillGroupModelMapper? _instance;
  static SkillGroupModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SkillGroupModelMapper._());
      SkillModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SkillGroupModel';

  static String _$category(SkillGroupModel v) => v.category;
  static const Field<SkillGroupModel, String> _f$category = Field(
    'category',
    _$category,
  );
  static List<SkillModel> _$skills(SkillGroupModel v) => v.skills;
  static const Field<SkillGroupModel, List<SkillModel>> _f$skills = Field(
    'skills',
    _$skills,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<SkillGroupModel> fields = const {
    #category: _f$category,
    #skills: _f$skills,
  };
  @override
  final bool ignoreNull = true;

  static SkillGroupModel _instantiate(DecodingData data) {
    return SkillGroupModel(
      category: data.dec(_f$category),
      skills: data.dec(_f$skills),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SkillGroupModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SkillGroupModel>(map);
  }

  static SkillGroupModel fromJson(String json) {
    return ensureInitialized().decodeJson<SkillGroupModel>(json);
  }
}

mixin SkillGroupModelMappable {
  String toJson() {
    return SkillGroupModelMapper.ensureInitialized()
        .encodeJson<SkillGroupModel>(this as SkillGroupModel);
  }

  Map<String, dynamic> toMap() {
    return SkillGroupModelMapper.ensureInitialized().encodeMap<SkillGroupModel>(
      this as SkillGroupModel,
    );
  }

  SkillGroupModelCopyWith<SkillGroupModel, SkillGroupModel, SkillGroupModel>
  get copyWith =>
      _SkillGroupModelCopyWithImpl<SkillGroupModel, SkillGroupModel>(
        this as SkillGroupModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SkillGroupModelMapper.ensureInitialized().stringifyValue(
      this as SkillGroupModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return SkillGroupModelMapper.ensureInitialized().equalsValue(
      this as SkillGroupModel,
      other,
    );
  }

  @override
  int get hashCode {
    return SkillGroupModelMapper.ensureInitialized().hashValue(
      this as SkillGroupModel,
    );
  }
}

extension SkillGroupModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SkillGroupModel, $Out> {
  SkillGroupModelCopyWith<$R, SkillGroupModel, $Out> get $asSkillGroupModel =>
      $base.as((v, t, t2) => _SkillGroupModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SkillGroupModelCopyWith<$R, $In extends SkillGroupModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, SkillModel, SkillModelCopyWith<$R, SkillModel, SkillModel>>
  get skills;
  $R call({String? category, List<SkillModel>? skills});
  SkillGroupModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SkillGroupModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SkillGroupModel, $Out>
    implements SkillGroupModelCopyWith<$R, SkillGroupModel, $Out> {
  _SkillGroupModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SkillGroupModel> $mapper =
      SkillGroupModelMapper.ensureInitialized();
  @override
  ListCopyWith<$R, SkillModel, SkillModelCopyWith<$R, SkillModel, SkillModel>>
  get skills => ListCopyWith(
    $value.skills,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(skills: v),
  );
  @override
  $R call({String? category, List<SkillModel>? skills}) => $apply(
    FieldCopyWithData({
      if (category != null) #category: category,
      if (skills != null) #skills: skills,
    }),
  );
  @override
  SkillGroupModel $make(CopyWithData data) => SkillGroupModel(
    category: data.get(#category, or: $value.category),
    skills: data.get(#skills, or: $value.skills),
  );

  @override
  SkillGroupModelCopyWith<$R2, SkillGroupModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SkillGroupModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

