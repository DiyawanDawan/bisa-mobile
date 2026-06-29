// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserEntity {

 String get id; String get name; String get email; String? get phone; String? get avatar; String? get companyName; String? get address; String get role; bool get isVerified; String? get kycStatus; bool get isKycVerified; String? get kycRejectionReason; DateTime get createdAt; String get tier; DateTime? get subscriptionExpiresAt; bool get enableNotifications;
/// Create a copy of UserEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserEntityCopyWith<UserEntity> get copyWith => _$UserEntityCopyWithImpl<UserEntity>(this as UserEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.address, address) || other.address == address)&&(identical(other.role, role) || other.role == role)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.kycStatus, kycStatus) || other.kycStatus == kycStatus)&&(identical(other.isKycVerified, isKycVerified) || other.isKycVerified == isKycVerified)&&(identical(other.kycRejectionReason, kycRejectionReason) || other.kycRejectionReason == kycRejectionReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.subscriptionExpiresAt, subscriptionExpiresAt) || other.subscriptionExpiresAt == subscriptionExpiresAt)&&(identical(other.enableNotifications, enableNotifications) || other.enableNotifications == enableNotifications));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,email,phone,avatar,companyName,address,role,isVerified,kycStatus,isKycVerified,kycRejectionReason,createdAt,tier,subscriptionExpiresAt,enableNotifications);

@override
String toString() {
  return 'UserEntity(id: $id, name: $name, email: $email, phone: $phone, avatar: $avatar, companyName: $companyName, address: $address, role: $role, isVerified: $isVerified, kycStatus: $kycStatus, isKycVerified: $isKycVerified, kycRejectionReason: $kycRejectionReason, createdAt: $createdAt, tier: $tier, subscriptionExpiresAt: $subscriptionExpiresAt, enableNotifications: $enableNotifications)';
}


}

/// @nodoc
abstract mixin class $UserEntityCopyWith<$Res>  {
  factory $UserEntityCopyWith(UserEntity value, $Res Function(UserEntity) _then) = _$UserEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email, String? phone, String? avatar, String? companyName, String? address, String role, bool isVerified, String? kycStatus, bool isKycVerified, String? kycRejectionReason, DateTime createdAt, String tier, DateTime? subscriptionExpiresAt, bool enableNotifications
});




}
/// @nodoc
class _$UserEntityCopyWithImpl<$Res>
    implements $UserEntityCopyWith<$Res> {
  _$UserEntityCopyWithImpl(this._self, this._then);

  final UserEntity _self;
  final $Res Function(UserEntity) _then;

/// Create a copy of UserEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? phone = freezed,Object? avatar = freezed,Object? companyName = freezed,Object? address = freezed,Object? role = null,Object? isVerified = null,Object? kycStatus = freezed,Object? isKycVerified = null,Object? kycRejectionReason = freezed,Object? createdAt = null,Object? tier = null,Object? subscriptionExpiresAt = freezed,Object? enableNotifications = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,kycStatus: freezed == kycStatus ? _self.kycStatus : kycStatus // ignore: cast_nullable_to_non_nullable
as String?,isKycVerified: null == isKycVerified ? _self.isKycVerified : isKycVerified // ignore: cast_nullable_to_non_nullable
as bool,kycRejectionReason: freezed == kycRejectionReason ? _self.kycRejectionReason : kycRejectionReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String,subscriptionExpiresAt: freezed == subscriptionExpiresAt ? _self.subscriptionExpiresAt : subscriptionExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,enableNotifications: null == enableNotifications ? _self.enableNotifications : enableNotifications // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserEntity].
extension UserEntityPatterns on UserEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserEntity value)  $default,){
final _that = this;
switch (_that) {
case _UserEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserEntity value)?  $default,){
final _that = this;
switch (_that) {
case _UserEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String? phone,  String? avatar,  String? companyName,  String? address,  String role,  bool isVerified,  String? kycStatus,  bool isKycVerified,  String? kycRejectionReason,  DateTime createdAt,  String tier,  DateTime? subscriptionExpiresAt,  bool enableNotifications)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserEntity() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.avatar,_that.companyName,_that.address,_that.role,_that.isVerified,_that.kycStatus,_that.isKycVerified,_that.kycRejectionReason,_that.createdAt,_that.tier,_that.subscriptionExpiresAt,_that.enableNotifications);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String? phone,  String? avatar,  String? companyName,  String? address,  String role,  bool isVerified,  String? kycStatus,  bool isKycVerified,  String? kycRejectionReason,  DateTime createdAt,  String tier,  DateTime? subscriptionExpiresAt,  bool enableNotifications)  $default,) {final _that = this;
switch (_that) {
case _UserEntity():
return $default(_that.id,_that.name,_that.email,_that.phone,_that.avatar,_that.companyName,_that.address,_that.role,_that.isVerified,_that.kycStatus,_that.isKycVerified,_that.kycRejectionReason,_that.createdAt,_that.tier,_that.subscriptionExpiresAt,_that.enableNotifications);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email,  String? phone,  String? avatar,  String? companyName,  String? address,  String role,  bool isVerified,  String? kycStatus,  bool isKycVerified,  String? kycRejectionReason,  DateTime createdAt,  String tier,  DateTime? subscriptionExpiresAt,  bool enableNotifications)?  $default,) {final _that = this;
switch (_that) {
case _UserEntity() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.avatar,_that.companyName,_that.address,_that.role,_that.isVerified,_that.kycStatus,_that.isKycVerified,_that.kycRejectionReason,_that.createdAt,_that.tier,_that.subscriptionExpiresAt,_that.enableNotifications);case _:
  return null;

}
}

}

/// @nodoc


class _UserEntity extends UserEntity {
  const _UserEntity({required this.id, required this.name, required this.email, this.phone, this.avatar, this.companyName, this.address, this.role = 'user', this.isVerified = false, this.kycStatus, this.isKycVerified = false, this.kycRejectionReason, required this.createdAt, this.tier = 'FREE', this.subscriptionExpiresAt, this.enableNotifications = true}): super._();
  

@override final  String id;
@override final  String name;
@override final  String email;
@override final  String? phone;
@override final  String? avatar;
@override final  String? companyName;
@override final  String? address;
@override@JsonKey() final  String role;
@override@JsonKey() final  bool isVerified;
@override final  String? kycStatus;
@override@JsonKey() final  bool isKycVerified;
@override final  String? kycRejectionReason;
@override final  DateTime createdAt;
@override@JsonKey() final  String tier;
@override final  DateTime? subscriptionExpiresAt;
@override@JsonKey() final  bool enableNotifications;

/// Create a copy of UserEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserEntityCopyWith<_UserEntity> get copyWith => __$UserEntityCopyWithImpl<_UserEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.address, address) || other.address == address)&&(identical(other.role, role) || other.role == role)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.kycStatus, kycStatus) || other.kycStatus == kycStatus)&&(identical(other.isKycVerified, isKycVerified) || other.isKycVerified == isKycVerified)&&(identical(other.kycRejectionReason, kycRejectionReason) || other.kycRejectionReason == kycRejectionReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.subscriptionExpiresAt, subscriptionExpiresAt) || other.subscriptionExpiresAt == subscriptionExpiresAt)&&(identical(other.enableNotifications, enableNotifications) || other.enableNotifications == enableNotifications));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,email,phone,avatar,companyName,address,role,isVerified,kycStatus,isKycVerified,kycRejectionReason,createdAt,tier,subscriptionExpiresAt,enableNotifications);

@override
String toString() {
  return 'UserEntity(id: $id, name: $name, email: $email, phone: $phone, avatar: $avatar, companyName: $companyName, address: $address, role: $role, isVerified: $isVerified, kycStatus: $kycStatus, isKycVerified: $isKycVerified, kycRejectionReason: $kycRejectionReason, createdAt: $createdAt, tier: $tier, subscriptionExpiresAt: $subscriptionExpiresAt, enableNotifications: $enableNotifications)';
}


}

/// @nodoc
abstract mixin class _$UserEntityCopyWith<$Res> implements $UserEntityCopyWith<$Res> {
  factory _$UserEntityCopyWith(_UserEntity value, $Res Function(_UserEntity) _then) = __$UserEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email, String? phone, String? avatar, String? companyName, String? address, String role, bool isVerified, String? kycStatus, bool isKycVerified, String? kycRejectionReason, DateTime createdAt, String tier, DateTime? subscriptionExpiresAt, bool enableNotifications
});




}
/// @nodoc
class __$UserEntityCopyWithImpl<$Res>
    implements _$UserEntityCopyWith<$Res> {
  __$UserEntityCopyWithImpl(this._self, this._then);

  final _UserEntity _self;
  final $Res Function(_UserEntity) _then;

/// Create a copy of UserEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? phone = freezed,Object? avatar = freezed,Object? companyName = freezed,Object? address = freezed,Object? role = null,Object? isVerified = null,Object? kycStatus = freezed,Object? isKycVerified = null,Object? kycRejectionReason = freezed,Object? createdAt = null,Object? tier = null,Object? subscriptionExpiresAt = freezed,Object? enableNotifications = null,}) {
  return _then(_UserEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,kycStatus: freezed == kycStatus ? _self.kycStatus : kycStatus // ignore: cast_nullable_to_non_nullable
as String?,isKycVerified: null == isKycVerified ? _self.isKycVerified : isKycVerified // ignore: cast_nullable_to_non_nullable
as bool,kycRejectionReason: freezed == kycRejectionReason ? _self.kycRejectionReason : kycRejectionReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String,subscriptionExpiresAt: freezed == subscriptionExpiresAt ? _self.subscriptionExpiresAt : subscriptionExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,enableNotifications: null == enableNotifications ? _self.enableNotifications : enableNotifications // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
