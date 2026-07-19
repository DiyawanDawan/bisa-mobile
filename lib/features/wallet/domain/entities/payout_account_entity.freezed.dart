// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payout_account_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PayoutAccountEntity {

 String get id; String get bankId; String get bankName; String get bankCode; String get accountNumber; String get accountName; bool get isMain;
/// Create a copy of PayoutAccountEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayoutAccountEntityCopyWith<PayoutAccountEntity> get copyWith => _$PayoutAccountEntityCopyWithImpl<PayoutAccountEntity>(this as PayoutAccountEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayoutAccountEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.bankId, bankId) || other.bankId == bankId)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.bankCode, bankCode) || other.bankCode == bankCode)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.isMain, isMain) || other.isMain == isMain));
}


@override
int get hashCode => Object.hash(runtimeType,id,bankId,bankName,bankCode,accountNumber,accountName,isMain);

@override
String toString() {
  return 'PayoutAccountEntity(id: $id, bankId: $bankId, bankName: $bankName, bankCode: $bankCode, accountNumber: $accountNumber, accountName: $accountName, isMain: $isMain)';
}


}

/// @nodoc
abstract mixin class $PayoutAccountEntityCopyWith<$Res>  {
  factory $PayoutAccountEntityCopyWith(PayoutAccountEntity value, $Res Function(PayoutAccountEntity) _then) = _$PayoutAccountEntityCopyWithImpl;
@useResult
$Res call({
 String id, String bankId, String bankName, String bankCode, String accountNumber, String accountName, bool isMain
});




}
/// @nodoc
class _$PayoutAccountEntityCopyWithImpl<$Res>
    implements $PayoutAccountEntityCopyWith<$Res> {
  _$PayoutAccountEntityCopyWithImpl(this._self, this._then);

  final PayoutAccountEntity _self;
  final $Res Function(PayoutAccountEntity) _then;

/// Create a copy of PayoutAccountEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bankId = null,Object? bankName = null,Object? bankCode = null,Object? accountNumber = null,Object? accountName = null,Object? isMain = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bankId: null == bankId ? _self.bankId : bankId // ignore: cast_nullable_to_non_nullable
as String,bankName: null == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String,bankCode: null == bankCode ? _self.bankCode : bankCode // ignore: cast_nullable_to_non_nullable
as String,accountNumber: null == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,isMain: null == isMain ? _self.isMain : isMain // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PayoutAccountEntity].
extension PayoutAccountEntityPatterns on PayoutAccountEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayoutAccountEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayoutAccountEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayoutAccountEntity value)  $default,){
final _that = this;
switch (_that) {
case _PayoutAccountEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayoutAccountEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PayoutAccountEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bankId,  String bankName,  String bankCode,  String accountNumber,  String accountName,  bool isMain)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayoutAccountEntity() when $default != null:
return $default(_that.id,_that.bankId,_that.bankName,_that.bankCode,_that.accountNumber,_that.accountName,_that.isMain);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bankId,  String bankName,  String bankCode,  String accountNumber,  String accountName,  bool isMain)  $default,) {final _that = this;
switch (_that) {
case _PayoutAccountEntity():
return $default(_that.id,_that.bankId,_that.bankName,_that.bankCode,_that.accountNumber,_that.accountName,_that.isMain);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bankId,  String bankName,  String bankCode,  String accountNumber,  String accountName,  bool isMain)?  $default,) {final _that = this;
switch (_that) {
case _PayoutAccountEntity() when $default != null:
return $default(_that.id,_that.bankId,_that.bankName,_that.bankCode,_that.accountNumber,_that.accountName,_that.isMain);case _:
  return null;

}
}

}

/// @nodoc


class _PayoutAccountEntity implements PayoutAccountEntity {
  const _PayoutAccountEntity({required this.id, required this.bankId, required this.bankName, required this.bankCode, required this.accountNumber, required this.accountName, this.isMain = false});
  

@override final  String id;
@override final  String bankId;
@override final  String bankName;
@override final  String bankCode;
@override final  String accountNumber;
@override final  String accountName;
@override@JsonKey() final  bool isMain;

/// Create a copy of PayoutAccountEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayoutAccountEntityCopyWith<_PayoutAccountEntity> get copyWith => __$PayoutAccountEntityCopyWithImpl<_PayoutAccountEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayoutAccountEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.bankId, bankId) || other.bankId == bankId)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.bankCode, bankCode) || other.bankCode == bankCode)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.isMain, isMain) || other.isMain == isMain));
}


@override
int get hashCode => Object.hash(runtimeType,id,bankId,bankName,bankCode,accountNumber,accountName,isMain);

@override
String toString() {
  return 'PayoutAccountEntity(id: $id, bankId: $bankId, bankName: $bankName, bankCode: $bankCode, accountNumber: $accountNumber, accountName: $accountName, isMain: $isMain)';
}


}

/// @nodoc
abstract mixin class _$PayoutAccountEntityCopyWith<$Res> implements $PayoutAccountEntityCopyWith<$Res> {
  factory _$PayoutAccountEntityCopyWith(_PayoutAccountEntity value, $Res Function(_PayoutAccountEntity) _then) = __$PayoutAccountEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String bankId, String bankName, String bankCode, String accountNumber, String accountName, bool isMain
});




}
/// @nodoc
class __$PayoutAccountEntityCopyWithImpl<$Res>
    implements _$PayoutAccountEntityCopyWith<$Res> {
  __$PayoutAccountEntityCopyWithImpl(this._self, this._then);

  final _PayoutAccountEntity _self;
  final $Res Function(_PayoutAccountEntity) _then;

/// Create a copy of PayoutAccountEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bankId = null,Object? bankName = null,Object? bankCode = null,Object? accountNumber = null,Object? accountName = null,Object? isMain = null,}) {
  return _then(_PayoutAccountEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bankId: null == bankId ? _self.bankId : bankId // ignore: cast_nullable_to_non_nullable
as String,bankName: null == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String,bankCode: null == bankCode ? _self.bankCode : bankCode // ignore: cast_nullable_to_non_nullable
as String,accountNumber: null == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,isMain: null == isMain ? _self.isMain : isMain // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
