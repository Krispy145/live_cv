// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'location_model.dart';

class LocationModelMapper extends ClassMapperBase<LocationModel> {
  LocationModelMapper._();

  static LocationModelMapper? _instance;
  static LocationModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LocationModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'LocationModel';

  static String? _$line1(LocationModel v) => v.line1;
  static const Field<LocationModel, String> _f$line1 = Field(
    'line1',
    _$line1,
    opt: true,
  );
  static String? _$line2(LocationModel v) => v.line2;
  static const Field<LocationModel, String> _f$line2 = Field(
    'line2',
    _$line2,
    opt: true,
  );
  static String? _$city(LocationModel v) => v.city;
  static const Field<LocationModel, String> _f$city = Field(
    'city',
    _$city,
    opt: true,
  );
  static String? _$region(LocationModel v) => v.region;
  static const Field<LocationModel, String> _f$region = Field(
    'region',
    _$region,
    opt: true,
  );
  static String? _$postalCode(LocationModel v) => v.postalCode;
  static const Field<LocationModel, String> _f$postalCode = Field(
    'postalCode',
    _$postalCode,
    key: r'postal_code',
    opt: true,
  );
  static String? _$country(LocationModel v) => v.country;
  static const Field<LocationModel, String> _f$country = Field(
    'country',
    _$country,
    opt: true,
  );

  @override
  final MappableFields<LocationModel> fields = const {
    #line1: _f$line1,
    #line2: _f$line2,
    #city: _f$city,
    #region: _f$region,
    #postalCode: _f$postalCode,
    #country: _f$country,
  };
  @override
  final bool ignoreNull = true;

  static LocationModel _instantiate(DecodingData data) {
    return LocationModel(
      line1: data.dec(_f$line1),
      line2: data.dec(_f$line2),
      city: data.dec(_f$city),
      region: data.dec(_f$region),
      postalCode: data.dec(_f$postalCode),
      country: data.dec(_f$country),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LocationModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LocationModel>(map);
  }

  static LocationModel fromJson(String json) {
    return ensureInitialized().decodeJson<LocationModel>(json);
  }
}

mixin LocationModelMappable {
  String toJson() {
    return LocationModelMapper.ensureInitialized().encodeJson<LocationModel>(
      this as LocationModel,
    );
  }

  Map<String, dynamic> toMap() {
    return LocationModelMapper.ensureInitialized().encodeMap<LocationModel>(
      this as LocationModel,
    );
  }

  LocationModelCopyWith<LocationModel, LocationModel, LocationModel>
  get copyWith => _LocationModelCopyWithImpl<LocationModel, LocationModel>(
    this as LocationModel,
    $identity,
    $identity,
  );
  @override
  bool operator ==(Object other) {
    return LocationModelMapper.ensureInitialized().equalsValue(
      this as LocationModel,
      other,
    );
  }

  @override
  int get hashCode {
    return LocationModelMapper.ensureInitialized().hashValue(
      this as LocationModel,
    );
  }
}

extension LocationModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LocationModel, $Out> {
  LocationModelCopyWith<$R, LocationModel, $Out> get $asLocationModel =>
      $base.as((v, t, t2) => _LocationModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class LocationModelCopyWith<$R, $In extends LocationModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? line1,
    String? line2,
    String? city,
    String? region,
    String? postalCode,
    String? country,
  });
  LocationModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LocationModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LocationModel, $Out>
    implements LocationModelCopyWith<$R, LocationModel, $Out> {
  _LocationModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LocationModel> $mapper =
      LocationModelMapper.ensureInitialized();
  @override
  $R call({
    Object? line1 = $none,
    Object? line2 = $none,
    Object? city = $none,
    Object? region = $none,
    Object? postalCode = $none,
    Object? country = $none,
  }) => $apply(
    FieldCopyWithData({
      if (line1 != $none) #line1: line1,
      if (line2 != $none) #line2: line2,
      if (city != $none) #city: city,
      if (region != $none) #region: region,
      if (postalCode != $none) #postalCode: postalCode,
      if (country != $none) #country: country,
    }),
  );
  @override
  LocationModel $make(CopyWithData data) => LocationModel(
    line1: data.get(#line1, or: $value.line1),
    line2: data.get(#line2, or: $value.line2),
    city: data.get(#city, or: $value.city),
    region: data.get(#region, or: $value.region),
    postalCode: data.get(#postalCode, or: $value.postalCode),
    country: data.get(#country, or: $value.country),
  );

  @override
  LocationModelCopyWith<$R2, LocationModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _LocationModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

