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

  late final _$addPortfolioPieceAsyncAction =
      AsyncAction('_AppStore.addPortfolioPiece', context: context);

  @override
  Future<void> addPortfolioPiece(PortfolioModel portfolio) {
    return _$addPortfolioPieceAsyncAction
        .run(() => super.addPortfolioPiece(portfolio));
  }

  late final _$updateUserDetailsAsyncAction =
      AsyncAction('_AppStore.updateUserDetails', context: context);

  @override
  Future<void> updateUserDetails() {
    return _$updateUserDetailsAsyncAction.run(() => super.updateUserDetails());
  }

  @override
  String toString() {
    return '''
userDetails: ${userDetails},
headerModel: ${headerModel}
    ''';
  }
}
