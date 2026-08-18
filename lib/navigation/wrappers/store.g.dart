// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStore, Store {
  late final _$userDetailsAtom =
      Atom(name: '_AppStore.userDetails', context: context);

  @override
  UserDetailsModel? get userDetails {
    _$userDetailsAtom.reportRead();
    return super.userDetails;
  }

  @override
  set userDetails(UserDetailsModel? value) {
    _$userDetailsAtom.reportWrite(value, super.userDetails, () {
      super.userDetails = value;
    });
  }

  late final _$headerModelAtom =
      Atom(name: '_AppStore.headerModel', context: context);

  @override
  HeaderModel get headerModel {
    _$headerModelAtom.reportRead();
    return super.headerModel;
  }

  bool _headerModelIsInitialized = false;

  @override
  set headerModel(HeaderModel value) {
    _$headerModelAtom.reportWrite(
        value, _headerModelIsInitialized ? super.headerModel : null, () {
      super.headerModel = value;
      _headerModelIsInitialized = true;
    });
  }

  late final _$cachedPdfBytesAtom =
      Atom(name: '_AppStore.cachedPdfBytes', context: context);

  @override
  Uint8List? get cachedPdfBytes {
    _$cachedPdfBytesAtom.reportRead();
    return super.cachedPdfBytes;
  }

  @override
  set cachedPdfBytes(Uint8List? value) {
    _$cachedPdfBytesAtom.reportWrite(value, super.cachedPdfBytes, () {
      super.cachedPdfBytes = value;
    });
  }

  late final _$isPdfGeneratingAtom =
      Atom(name: '_AppStore.isPdfGenerating', context: context);

  @override
  bool get isPdfGenerating {
    _$isPdfGeneratingAtom.reportRead();
    return super.isPdfGenerating;
  }

  @override
  set isPdfGenerating(bool value) {
    _$isPdfGeneratingAtom.reportWrite(value, super.isPdfGenerating, () {
      super.isPdfGenerating = value;
    });
  }

  late final _$pdfErrorAtom =
      Atom(name: '_AppStore.pdfError', context: context);

  @override
  String? get pdfError {
    _$pdfErrorAtom.reportRead();
    return super.pdfError;
  }

  @override
  set pdfError(String? value) {
    _$pdfErrorAtom.reportWrite(value, super.pdfError, () {
      super.pdfError = value;
    });
  }

  late final _$updateUserDetailsAsyncAction =
      AsyncAction('_AppStore.updateUserDetails', context: context);

  @override
  Future<void> updateUserDetails() {
    return _$updateUserDetailsAsyncAction.run(() => super.updateUserDetails());
  }

  late final _$removeTimelineAsyncAction =
      AsyncAction('_AppStore.removeTimeline', context: context);

  @override
  Future<RequestResponse> removeTimeline(
      {required String id, required bool isEducation}) {
    return _$removeTimelineAsyncAction
        .run(() => super.removeTimeline(id: id, isEducation: isEducation));
  }

  late final _$refreshPdfCacheAsyncAction =
      AsyncAction('_AppStore.refreshPdfCache', context: context);

  @override
  Future<void> refreshPdfCache() {
    return _$refreshPdfCacheAsyncAction.run(() => super.refreshPdfCache());
  }

  late final _$_AppStoreActionController =
      ActionController(name: '_AppStore', context: context);

  @override
  Future<RequestResponse> upsertExperience(TimelineModel entry) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.upsertExperience');
    try {
      return super.upsertExperience(entry);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<RequestResponse> upsertEducation(TimelineModel entry) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.upsertEducation');
    try {
      return super.upsertEducation(entry);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
userDetails: ${userDetails},
headerModel: ${headerModel},
cachedPdfBytes: ${cachedPdfBytes},
isPdfGenerating: ${isPdfGenerating},
pdfError: ${pdfError}
    ''';
  }
}
