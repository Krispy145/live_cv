// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_details_model.dart';

class UserDetailsModelMapper extends ClassMapperBase<UserDetailsModel> {
  UserDetailsModelMapper._();

  static UserDetailsModelMapper? _instance;
  static UserDetailsModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserDetailsModelMapper._());
      LocationModelMapper.ensureInitialized();
      TimelineModelMapper.ensureInitialized();
      SkillGroupModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UserDetailsModel';

  static String _$id(UserDetailsModel v) => v.id;
  static const Field<UserDetailsModel, String> _f$id = Field('id', _$id);
  static String _$firstName(UserDetailsModel v) => v.firstName;
  static const Field<UserDetailsModel, String> _f$firstName = Field(
    'firstName',
    _$firstName,
    key: r'name',
  );
  static String _$lastName(UserDetailsModel v) => v.lastName;
  static const Field<UserDetailsModel, String> _f$lastName = Field(
    'lastName',
    _$lastName,
    key: r'surname',
  );
  static String? _$email(UserDetailsModel v) => v.email;
  static const Field<UserDetailsModel, String> _f$email = Field(
    'email',
    _$email,
    opt: true,
  );
  static String? _$phone(UserDetailsModel v) => v.phone;
  static const Field<UserDetailsModel, String> _f$phone = Field(
    'phone',
    _$phone,
    opt: true,
  );
  static String? _$githubUrl(UserDetailsModel v) => v.githubUrl;
  static const Field<UserDetailsModel, String> _f$githubUrl = Field(
    'githubUrl',
    _$githubUrl,
    key: r'github_url',
    opt: true,
  );
  static String? _$linkedinUrl(UserDetailsModel v) => v.linkedinUrl;
  static const Field<UserDetailsModel, String> _f$linkedinUrl = Field(
    'linkedinUrl',
    _$linkedinUrl,
    key: r'linkedin_url',
    opt: true,
  );
  static LocationModel? _$location(UserDetailsModel v) => v.location;
  static const Field<UserDetailsModel, LocationModel> _f$location = Field(
    'location',
    _$location,
    opt: true,
  );
  static String? _$imageUrl(UserDetailsModel v) => v.imageUrl;
  static const Field<UserDetailsModel, String> _f$imageUrl = Field(
    'imageUrl',
    _$imageUrl,
    key: r'image_url',
    opt: true,
  );
  static String? _$summary(UserDetailsModel v) => v.summary;
  static const Field<UserDetailsModel, String> _f$summary = Field(
    'summary',
    _$summary,
    opt: true,
  );
  static List<TimelineModel> _$experience(UserDetailsModel v) => v.experience;
  static const Field<UserDetailsModel, List<TimelineModel>> _f$experience =
      Field('experience', _$experience, opt: true, def: const []);
  static List<TimelineModel> _$education(UserDetailsModel v) => v.education;
  static const Field<UserDetailsModel, List<TimelineModel>> _f$education =
      Field('education', _$education, opt: true, def: const []);
  static List<SkillGroupModel> _$skillGroups(UserDetailsModel v) =>
      v.skillGroups;
  static const Field<UserDetailsModel, List<SkillGroupModel>> _f$skillGroups =
      Field(
        'skillGroups',
        _$skillGroups,
        key: r'skills',
        opt: true,
        def: const [],
      );

  @override
  final MappableFields<UserDetailsModel> fields = const {
    #id: _f$id,
    #firstName: _f$firstName,
    #lastName: _f$lastName,
    #email: _f$email,
    #phone: _f$phone,
    #githubUrl: _f$githubUrl,
    #linkedinUrl: _f$linkedinUrl,
    #location: _f$location,
    #imageUrl: _f$imageUrl,
    #summary: _f$summary,
    #experience: _f$experience,
    #education: _f$education,
    #skillGroups: _f$skillGroups,
  };
  @override
  final bool ignoreNull = true;

  static UserDetailsModel _instantiate(DecodingData data) {
    return UserDetailsModel(
      id: data.dec(_f$id),
      firstName: data.dec(_f$firstName),
      lastName: data.dec(_f$lastName),
      email: data.dec(_f$email),
      phone: data.dec(_f$phone),
      githubUrl: data.dec(_f$githubUrl),
      linkedinUrl: data.dec(_f$linkedinUrl),
      location: data.dec(_f$location),
      imageUrl: data.dec(_f$imageUrl),
      summary: data.dec(_f$summary),
      experience: data.dec(_f$experience),
      education: data.dec(_f$education),
      skillGroups: data.dec(_f$skillGroups),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserDetailsModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserDetailsModel>(map);
  }

  static UserDetailsModel fromJson(String json) {
    return ensureInitialized().decodeJson<UserDetailsModel>(json);
  }
}

mixin UserDetailsModelMappable {
  String toJson() {
    return UserDetailsModelMapper.ensureInitialized()
        .encodeJson<UserDetailsModel>(this as UserDetailsModel);
  }

  Map<String, dynamic> toMap() {
    return UserDetailsModelMapper.ensureInitialized()
        .encodeMap<UserDetailsModel>(this as UserDetailsModel);
  }

  UserDetailsModelCopyWith<UserDetailsModel, UserDetailsModel, UserDetailsModel>
  get copyWith =>
      _UserDetailsModelCopyWithImpl<UserDetailsModel, UserDetailsModel>(
        this as UserDetailsModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UserDetailsModelMapper.ensureInitialized().stringifyValue(
      this as UserDetailsModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserDetailsModelMapper.ensureInitialized().equalsValue(
      this as UserDetailsModel,
      other,
    );
  }

  @override
  int get hashCode {
    return UserDetailsModelMapper.ensureInitialized().hashValue(
      this as UserDetailsModel,
    );
  }
}

extension UserDetailsModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserDetailsModel, $Out> {
  UserDetailsModelCopyWith<$R, UserDetailsModel, $Out>
  get $asUserDetailsModel =>
      $base.as((v, t, t2) => _UserDetailsModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserDetailsModelCopyWith<$R, $In extends UserDetailsModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  LocationModelCopyWith<$R, LocationModel, LocationModel>? get location;
  ListCopyWith<
    $R,
    TimelineModel,
    TimelineModelCopyWith<$R, TimelineModel, TimelineModel>
  >
  get experience;
  ListCopyWith<
    $R,
    TimelineModel,
    TimelineModelCopyWith<$R, TimelineModel, TimelineModel>
  >
  get education;
  ListCopyWith<
    $R,
    SkillGroupModel,
    SkillGroupModelCopyWith<$R, SkillGroupModel, SkillGroupModel>
  >
  get skillGroups;
  $R call({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? githubUrl,
    String? linkedinUrl,
    LocationModel? location,
    String? imageUrl,
    String? summary,
    List<TimelineModel>? experience,
    List<TimelineModel>? education,
    List<SkillGroupModel>? skillGroups,
  });
  UserDetailsModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UserDetailsModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserDetailsModel, $Out>
    implements UserDetailsModelCopyWith<$R, UserDetailsModel, $Out> {
  _UserDetailsModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserDetailsModel> $mapper =
      UserDetailsModelMapper.ensureInitialized();
  @override
  LocationModelCopyWith<$R, LocationModel, LocationModel>? get location =>
      $value.location?.copyWith.$chain((v) => call(location: v));
  @override
  ListCopyWith<
    $R,
    TimelineModel,
    TimelineModelCopyWith<$R, TimelineModel, TimelineModel>
  >
  get experience => ListCopyWith(
    $value.experience,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(experience: v),
  );
  @override
  ListCopyWith<
    $R,
    TimelineModel,
    TimelineModelCopyWith<$R, TimelineModel, TimelineModel>
  >
  get education => ListCopyWith(
    $value.education,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(education: v),
  );
  @override
  ListCopyWith<
    $R,
    SkillGroupModel,
    SkillGroupModelCopyWith<$R, SkillGroupModel, SkillGroupModel>
  >
  get skillGroups => ListCopyWith(
    $value.skillGroups,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(skillGroups: v),
  );
  @override
  $R call({
    String? id,
    String? firstName,
    String? lastName,
    Object? email = $none,
    Object? phone = $none,
    Object? githubUrl = $none,
    Object? linkedinUrl = $none,
    Object? location = $none,
    Object? imageUrl = $none,
    Object? summary = $none,
    List<TimelineModel>? experience,
    List<TimelineModel>? education,
    List<SkillGroupModel>? skillGroups,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (firstName != null) #firstName: firstName,
      if (lastName != null) #lastName: lastName,
      if (email != $none) #email: email,
      if (phone != $none) #phone: phone,
      if (githubUrl != $none) #githubUrl: githubUrl,
      if (linkedinUrl != $none) #linkedinUrl: linkedinUrl,
      if (location != $none) #location: location,
      if (imageUrl != $none) #imageUrl: imageUrl,
      if (summary != $none) #summary: summary,
      if (experience != null) #experience: experience,
      if (education != null) #education: education,
      if (skillGroups != null) #skillGroups: skillGroups,
    }),
  );
  @override
  UserDetailsModel $make(CopyWithData data) => UserDetailsModel(
    id: data.get(#id, or: $value.id),
    firstName: data.get(#firstName, or: $value.firstName),
    lastName: data.get(#lastName, or: $value.lastName),
    email: data.get(#email, or: $value.email),
    phone: data.get(#phone, or: $value.phone),
    githubUrl: data.get(#githubUrl, or: $value.githubUrl),
    linkedinUrl: data.get(#linkedinUrl, or: $value.linkedinUrl),
    location: data.get(#location, or: $value.location),
    imageUrl: data.get(#imageUrl, or: $value.imageUrl),
    summary: data.get(#summary, or: $value.summary),
    experience: data.get(#experience, or: $value.experience),
    education: data.get(#education, or: $value.education),
    skillGroups: data.get(#skillGroups, or: $value.skillGroups),
  );

  @override
  UserDetailsModelCopyWith<$R2, UserDetailsModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UserDetailsModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

