// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payout_account_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PayoutAccountModel {

 String get id; String get bankId; String get accountNumber; String get accountName;@JsonKey(name: 'isMain') bool get isMain; Map<String, dynamic>? get bank;
/// Create a copy of PayoutAccountModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayoutAccountModelCopyWith<PayoutAccountModel> get copyWith => _$PayoutAccountModelCopyWithImpl<PayoutAccountModel>(this as PayoutAccountModel, _$identity);

  /// Serializes this PayoutAccountModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayoutAccountModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bankId, bankId) || other.bankId == bankId)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.isMain, isMain) || other.isMain == isMain)&&const DeepCollectionEquality().equals(other.bank, bank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bankId,accountNumber,accountName,isMain,const DeepCollectionEquality().hash(bank));

@override
String toString() {
  return 'PayoutAccountModel(id: $id, bankId: $bankId, accountNumber: $accountNumber, accountName: $accountName, isMain: $isMain, bank: $bank)';
}


}

/// @nodoc
abstract mixin class $PayoutAccountModelCopyWith<$Res>  {
  factory $PayoutAccountModelCopyWith(PayoutAccountModel value, $Res Function(PayoutAccountModel) _then) = _$PayoutAccountModelCopyWithImpl;
@useResult
$Res call({
 String id, String bankId, String accountNumber, String accountName,@JsonKey(name: 'isMain') bool isMain, Map<String, dynamic>? bank
});




}
/// @nodoc
class _$PayoutAccountModelCopyWithImpl<$Res>
    implements $PayoutAccountModelCopyWith<$Res> {
  _$PayoutAccountModelCopyWithImpl(this._self, this._then);

  final PayoutAccountModel _self;
  final $Res Function(PayoutAccountModel) _then;

/// Create a copy of PayoutAccountModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bankId = null,Object? accountNumber = null,Object? accountName = null,Object? isMain = null,Object? bank = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bankId: null == bankId ? _self.bankId : bankId // ignore: cast_nullable_to_non_nullable
as String,accountNumber: null == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,isMain: null == isMain ? _self.isMain : isMain // ignore: cast_nullable_to_non_nullable
as bool,bank: freezed == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [PayoutAccountModel].
extension PayoutAccountModelPatterns on PayoutAccountModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayoutAccountModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayoutAccountModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayoutAccountModel value)  $default,){
final _that = this;
switch (_that) {
case _PayoutAccountModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayoutAccountModel value)?  $default,){
final _that = this;
switch (_that) {
case _PayoutAccountModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bankId,  String accountNumber,  String accountName, @JsonKey(name: 'isMain')  bool isMain,  Map<String, dynamic>? bank)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayoutAccountModel() when $default != null:
return $default(_that.id,_that.bankId,_that.accountNumber,_that.accountName,_that.isMain,_that.bank);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bankId,  String accountNumber,  String accountName, @JsonKey(name: 'isMain')  bool isMain,  Map<String, dynamic>? bank)  $default,) {final _that = this;
switch (_that) {
case _PayoutAccountModel():
return $default(_that.id,_that.bankId,_that.accountNumber,_that.accountName,_that.isMain,_that.bank);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bankId,  String accountNumber,  String accountName, @JsonKey(name: 'isMain')  bool isMain,  Map<String, dynamic>? bank)?  $default,) {final _that = this;
switch (_that) {
case _PayoutAccountModel() when $default != null:
return $default(_that.id,_that.bankId,_that.accountNumber,_that.accountName,_that.isMain,_that.bank);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PayoutAccountModel extends PayoutAccountModel {
  const _PayoutAccountModel({required this.id, required this.bankId, required this.accountNumber, required this.accountName, @JsonKey(name: 'isMain') this.isMain = false, final  Map<String, dynamic>? bank}): _bank = bank,super._();
  factory _PayoutAccountModel.fromJson(Map<String, dynamic> json) => _$PayoutAccountModelFromJson(json);

@override final  String id;
@override final  String bankId;
@override final  String accountNumber;
@override final  String accountName;
@override@JsonKey(name: 'isMain') final  bool isMain;
 final  Map<String, dynamic>? _bank;
@override Map<String, dynamic>? get bank {
  final value = _bank;
  if (value == null) return null;
  if (_bank is EqualUnmodifiableMapView) return _bank;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of PayoutAccountModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayoutAccountModelCopyWith<_PayoutAccountModel> get copyWith => __$PayoutAccountModelCopyWithImpl<_PayoutAccountModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PayoutAccountModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayoutAccountModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bankId, bankId) || other.bankId == bankId)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.isMain, isMain) || other.isMain == isMain)&&const DeepCollectionEquality().equals(other._bank, _bank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bankId,accountNumber,accountName,isMain,const DeepCollectionEquality().hash(_bank));

@override
String toString() {
  return 'PayoutAccountModel(id: $id, bankId: $bankId, accountNumber: $accountNumber, accountName: $accountName, isMain: $isMain, bank: $bank)';
}


}

/// @nodoc
abstract mixin class _$PayoutAccountModelCopyWith<$Res> implements $PayoutAccountModelCopyWith<$Res> {
  factory _$PayoutAccountModelCopyWith(_PayoutAccountModel value, $Res Function(_PayoutAccountModel) _then) = __$PayoutAccountModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String bankId, String accountNumber, String accountName,@JsonKey(name: 'isMain') bool isMain, Map<String, dynamic>? bank
});




}
/// @nodoc
class __$PayoutAccountModelCopyWithImpl<$Res>
    implements _$PayoutAccountModelCopyWith<$Res> {
  __$PayoutAccountModelCopyWithImpl(this._self, this._then);

  final _PayoutAccountModel _self;
  final $Res Function(_PayoutAccountModel) _then;

/// Create a copy of PayoutAccountModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bankId = null,Object? accountNumber = null,Object? accountName = null,Object? isMain = null,Object? bank = freezed,}) {
  return _then(_PayoutAccountModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bankId: null == bankId ? _self.bankId : bankId // ignore: cast_nullable_to_non_nullable
as String,accountNumber: null == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,isMain: null == isMain ? _self.isMain : isMain // ignore: cast_nullable_to_non_nullable
as bool,bank: freezed == bank ? _self._bank : bank // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
