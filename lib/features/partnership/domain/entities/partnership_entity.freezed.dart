// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'partnership_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PartnershipUserEntity {

 String get id; String get fullName; String? get avatarUrl; String get role; String? get province; String? get regency; bool get isVerified; String? get companyName; String? get businessType;
/// Create a copy of PartnershipUserEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartnershipUserEntityCopyWith<PartnershipUserEntity> get copyWith => _$PartnershipUserEntityCopyWithImpl<PartnershipUserEntity>(this as PartnershipUserEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartnershipUserEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.businessType, businessType) || other.businessType == businessType));
}


@override
int get hashCode => Object.hash(runtimeType,id,fullName,avatarUrl,role,province,regency,isVerified,companyName,businessType);

@override
String toString() {
  return 'PartnershipUserEntity(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, role: $role, province: $province, regency: $regency, isVerified: $isVerified, companyName: $companyName, businessType: $businessType)';
}


}

/// @nodoc
abstract mixin class $PartnershipUserEntityCopyWith<$Res>  {
  factory $PartnershipUserEntityCopyWith(PartnershipUserEntity value, $Res Function(PartnershipUserEntity) _then) = _$PartnershipUserEntityCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String? avatarUrl, String role, String? province, String? regency, bool isVerified, String? companyName, String? businessType
});




}
/// @nodoc
class _$PartnershipUserEntityCopyWithImpl<$Res>
    implements $PartnershipUserEntityCopyWith<$Res> {
  _$PartnershipUserEntityCopyWithImpl(this._self, this._then);

  final PartnershipUserEntity _self;
  final $Res Function(PartnershipUserEntity) _then;

/// Create a copy of PartnershipUserEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? avatarUrl = freezed,Object? role = null,Object? province = freezed,Object? regency = freezed,Object? isVerified = null,Object? companyName = freezed,Object? businessType = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,businessType: freezed == businessType ? _self.businessType : businessType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PartnershipUserEntity].
extension PartnershipUserEntityPatterns on PartnershipUserEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartnershipUserEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartnershipUserEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartnershipUserEntity value)  $default,){
final _that = this;
switch (_that) {
case _PartnershipUserEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartnershipUserEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PartnershipUserEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fullName,  String? avatarUrl,  String role,  String? province,  String? regency,  bool isVerified,  String? companyName,  String? businessType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartnershipUserEntity() when $default != null:
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.role,_that.province,_that.regency,_that.isVerified,_that.companyName,_that.businessType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fullName,  String? avatarUrl,  String role,  String? province,  String? regency,  bool isVerified,  String? companyName,  String? businessType)  $default,) {final _that = this;
switch (_that) {
case _PartnershipUserEntity():
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.role,_that.province,_that.regency,_that.isVerified,_that.companyName,_that.businessType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fullName,  String? avatarUrl,  String role,  String? province,  String? regency,  bool isVerified,  String? companyName,  String? businessType)?  $default,) {final _that = this;
switch (_that) {
case _PartnershipUserEntity() when $default != null:
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.role,_that.province,_that.regency,_that.isVerified,_that.companyName,_that.businessType);case _:
  return null;

}
}

}

/// @nodoc


class _PartnershipUserEntity implements PartnershipUserEntity {
  const _PartnershipUserEntity({required this.id, required this.fullName, this.avatarUrl, required this.role, this.province, this.regency, this.isVerified = false, this.companyName, this.businessType});
  

@override final  String id;
@override final  String fullName;
@override final  String? avatarUrl;
@override final  String role;
@override final  String? province;
@override final  String? regency;
@override@JsonKey() final  bool isVerified;
@override final  String? companyName;
@override final  String? businessType;

/// Create a copy of PartnershipUserEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartnershipUserEntityCopyWith<_PartnershipUserEntity> get copyWith => __$PartnershipUserEntityCopyWithImpl<_PartnershipUserEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartnershipUserEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.businessType, businessType) || other.businessType == businessType));
}


@override
int get hashCode => Object.hash(runtimeType,id,fullName,avatarUrl,role,province,regency,isVerified,companyName,businessType);

@override
String toString() {
  return 'PartnershipUserEntity(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, role: $role, province: $province, regency: $regency, isVerified: $isVerified, companyName: $companyName, businessType: $businessType)';
}


}

/// @nodoc
abstract mixin class _$PartnershipUserEntityCopyWith<$Res> implements $PartnershipUserEntityCopyWith<$Res> {
  factory _$PartnershipUserEntityCopyWith(_PartnershipUserEntity value, $Res Function(_PartnershipUserEntity) _then) = __$PartnershipUserEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String? avatarUrl, String role, String? province, String? regency, bool isVerified, String? companyName, String? businessType
});




}
/// @nodoc
class __$PartnershipUserEntityCopyWithImpl<$Res>
    implements _$PartnershipUserEntityCopyWith<$Res> {
  __$PartnershipUserEntityCopyWithImpl(this._self, this._then);

  final _PartnershipUserEntity _self;
  final $Res Function(_PartnershipUserEntity) _then;

/// Create a copy of PartnershipUserEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? avatarUrl = freezed,Object? role = null,Object? province = freezed,Object? regency = freezed,Object? isVerified = null,Object? companyName = freezed,Object? businessType = freezed,}) {
  return _then(_PartnershipUserEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,businessType: freezed == businessType ? _self.businessType : businessType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$PartnershipSignatureEntity {

 String get party; String get label; DateTime? get signedAt; String? get signerName; String? get signerTitle; String? get companyName;
/// Create a copy of PartnershipSignatureEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartnershipSignatureEntityCopyWith<PartnershipSignatureEntity> get copyWith => _$PartnershipSignatureEntityCopyWithImpl<PartnershipSignatureEntity>(this as PartnershipSignatureEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartnershipSignatureEntity&&(identical(other.party, party) || other.party == party)&&(identical(other.label, label) || other.label == label)&&(identical(other.signedAt, signedAt) || other.signedAt == signedAt)&&(identical(other.signerName, signerName) || other.signerName == signerName)&&(identical(other.signerTitle, signerTitle) || other.signerTitle == signerTitle)&&(identical(other.companyName, companyName) || other.companyName == companyName));
}


@override
int get hashCode => Object.hash(runtimeType,party,label,signedAt,signerName,signerTitle,companyName);

@override
String toString() {
  return 'PartnershipSignatureEntity(party: $party, label: $label, signedAt: $signedAt, signerName: $signerName, signerTitle: $signerTitle, companyName: $companyName)';
}


}

/// @nodoc
abstract mixin class $PartnershipSignatureEntityCopyWith<$Res>  {
  factory $PartnershipSignatureEntityCopyWith(PartnershipSignatureEntity value, $Res Function(PartnershipSignatureEntity) _then) = _$PartnershipSignatureEntityCopyWithImpl;
@useResult
$Res call({
 String party, String label, DateTime? signedAt, String? signerName, String? signerTitle, String? companyName
});




}
/// @nodoc
class _$PartnershipSignatureEntityCopyWithImpl<$Res>
    implements $PartnershipSignatureEntityCopyWith<$Res> {
  _$PartnershipSignatureEntityCopyWithImpl(this._self, this._then);

  final PartnershipSignatureEntity _self;
  final $Res Function(PartnershipSignatureEntity) _then;

/// Create a copy of PartnershipSignatureEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? party = null,Object? label = null,Object? signedAt = freezed,Object? signerName = freezed,Object? signerTitle = freezed,Object? companyName = freezed,}) {
  return _then(_self.copyWith(
party: null == party ? _self.party : party // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,signedAt: freezed == signedAt ? _self.signedAt : signedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,signerName: freezed == signerName ? _self.signerName : signerName // ignore: cast_nullable_to_non_nullable
as String?,signerTitle: freezed == signerTitle ? _self.signerTitle : signerTitle // ignore: cast_nullable_to_non_nullable
as String?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PartnershipSignatureEntity].
extension PartnershipSignatureEntityPatterns on PartnershipSignatureEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartnershipSignatureEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartnershipSignatureEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartnershipSignatureEntity value)  $default,){
final _that = this;
switch (_that) {
case _PartnershipSignatureEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartnershipSignatureEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PartnershipSignatureEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String party,  String label,  DateTime? signedAt,  String? signerName,  String? signerTitle,  String? companyName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartnershipSignatureEntity() when $default != null:
return $default(_that.party,_that.label,_that.signedAt,_that.signerName,_that.signerTitle,_that.companyName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String party,  String label,  DateTime? signedAt,  String? signerName,  String? signerTitle,  String? companyName)  $default,) {final _that = this;
switch (_that) {
case _PartnershipSignatureEntity():
return $default(_that.party,_that.label,_that.signedAt,_that.signerName,_that.signerTitle,_that.companyName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String party,  String label,  DateTime? signedAt,  String? signerName,  String? signerTitle,  String? companyName)?  $default,) {final _that = this;
switch (_that) {
case _PartnershipSignatureEntity() when $default != null:
return $default(_that.party,_that.label,_that.signedAt,_that.signerName,_that.signerTitle,_that.companyName);case _:
  return null;

}
}

}

/// @nodoc


class _PartnershipSignatureEntity implements PartnershipSignatureEntity {
  const _PartnershipSignatureEntity({required this.party, required this.label, this.signedAt, this.signerName, this.signerTitle, this.companyName});
  

@override final  String party;
@override final  String label;
@override final  DateTime? signedAt;
@override final  String? signerName;
@override final  String? signerTitle;
@override final  String? companyName;

/// Create a copy of PartnershipSignatureEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartnershipSignatureEntityCopyWith<_PartnershipSignatureEntity> get copyWith => __$PartnershipSignatureEntityCopyWithImpl<_PartnershipSignatureEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartnershipSignatureEntity&&(identical(other.party, party) || other.party == party)&&(identical(other.label, label) || other.label == label)&&(identical(other.signedAt, signedAt) || other.signedAt == signedAt)&&(identical(other.signerName, signerName) || other.signerName == signerName)&&(identical(other.signerTitle, signerTitle) || other.signerTitle == signerTitle)&&(identical(other.companyName, companyName) || other.companyName == companyName));
}


@override
int get hashCode => Object.hash(runtimeType,party,label,signedAt,signerName,signerTitle,companyName);

@override
String toString() {
  return 'PartnershipSignatureEntity(party: $party, label: $label, signedAt: $signedAt, signerName: $signerName, signerTitle: $signerTitle, companyName: $companyName)';
}


}

/// @nodoc
abstract mixin class _$PartnershipSignatureEntityCopyWith<$Res> implements $PartnershipSignatureEntityCopyWith<$Res> {
  factory _$PartnershipSignatureEntityCopyWith(_PartnershipSignatureEntity value, $Res Function(_PartnershipSignatureEntity) _then) = __$PartnershipSignatureEntityCopyWithImpl;
@override @useResult
$Res call({
 String party, String label, DateTime? signedAt, String? signerName, String? signerTitle, String? companyName
});




}
/// @nodoc
class __$PartnershipSignatureEntityCopyWithImpl<$Res>
    implements _$PartnershipSignatureEntityCopyWith<$Res> {
  __$PartnershipSignatureEntityCopyWithImpl(this._self, this._then);

  final _PartnershipSignatureEntity _self;
  final $Res Function(_PartnershipSignatureEntity) _then;

/// Create a copy of PartnershipSignatureEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? party = null,Object? label = null,Object? signedAt = freezed,Object? signerName = freezed,Object? signerTitle = freezed,Object? companyName = freezed,}) {
  return _then(_PartnershipSignatureEntity(
party: null == party ? _self.party : party // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,signedAt: freezed == signedAt ? _self.signedAt : signedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,signerName: freezed == signerName ? _self.signerName : signerName // ignore: cast_nullable_to_non_nullable
as String?,signerTitle: freezed == signerTitle ? _self.signerTitle : signerTitle // ignore: cast_nullable_to_non_nullable
as String?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$PartnershipEntity {

 String get id; String get contractNumber; String get buyerId; String get supplierId; String get tier; String get status; String get title; String? get description; String? get productCategory; double? get estimatedMonthlyQty; String? get priceAgreement; String? get deliveryTerms; String? get paymentTerms; String? get specialTerms; DateTime get startDate; DateTime get endDate; DateTime? get buyerSignedAt; DateTime? get sellerSignedAt; DateTime? get platformSignedAt; String? get buyerSignerName; String? get buyerSignerTitle; String? get buyerCompanyName; String? get sellerSignerName; String? get sellerSignerTitle; String? get sellerCompanyName; String? get platformSignerName; String? get platformSignerTitle; bool get isFullySigned; int get requiredSigners; int get signedCount; List<PartnershipSignatureEntity> get signatures; String? get rejectionReason; DateTime? get terminatedAt; int get renewalCount; DateTime? get renewalProposedEndDate; String? get renewalRequestedBy; String? get renewalNote; int? get daysUntilExpiry; String? get contractPhase; bool get canRenew; bool get isRenewalPending; DateTime get createdAt; PartnershipUserEntity get buyer; PartnershipUserEntity get supplier;
/// Create a copy of PartnershipEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartnershipEntityCopyWith<PartnershipEntity> get copyWith => _$PartnershipEntityCopyWithImpl<PartnershipEntity>(this as PartnershipEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartnershipEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.contractNumber, contractNumber) || other.contractNumber == contractNumber)&&(identical(other.buyerId, buyerId) || other.buyerId == buyerId)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.status, status) || other.status == status)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.productCategory, productCategory) || other.productCategory == productCategory)&&(identical(other.estimatedMonthlyQty, estimatedMonthlyQty) || other.estimatedMonthlyQty == estimatedMonthlyQty)&&(identical(other.priceAgreement, priceAgreement) || other.priceAgreement == priceAgreement)&&(identical(other.deliveryTerms, deliveryTerms) || other.deliveryTerms == deliveryTerms)&&(identical(other.paymentTerms, paymentTerms) || other.paymentTerms == paymentTerms)&&(identical(other.specialTerms, specialTerms) || other.specialTerms == specialTerms)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.buyerSignedAt, buyerSignedAt) || other.buyerSignedAt == buyerSignedAt)&&(identical(other.sellerSignedAt, sellerSignedAt) || other.sellerSignedAt == sellerSignedAt)&&(identical(other.platformSignedAt, platformSignedAt) || other.platformSignedAt == platformSignedAt)&&(identical(other.buyerSignerName, buyerSignerName) || other.buyerSignerName == buyerSignerName)&&(identical(other.buyerSignerTitle, buyerSignerTitle) || other.buyerSignerTitle == buyerSignerTitle)&&(identical(other.buyerCompanyName, buyerCompanyName) || other.buyerCompanyName == buyerCompanyName)&&(identical(other.sellerSignerName, sellerSignerName) || other.sellerSignerName == sellerSignerName)&&(identical(other.sellerSignerTitle, sellerSignerTitle) || other.sellerSignerTitle == sellerSignerTitle)&&(identical(other.sellerCompanyName, sellerCompanyName) || other.sellerCompanyName == sellerCompanyName)&&(identical(other.platformSignerName, platformSignerName) || other.platformSignerName == platformSignerName)&&(identical(other.platformSignerTitle, platformSignerTitle) || other.platformSignerTitle == platformSignerTitle)&&(identical(other.isFullySigned, isFullySigned) || other.isFullySigned == isFullySigned)&&(identical(other.requiredSigners, requiredSigners) || other.requiredSigners == requiredSigners)&&(identical(other.signedCount, signedCount) || other.signedCount == signedCount)&&const DeepCollectionEquality().equals(other.signatures, signatures)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.terminatedAt, terminatedAt) || other.terminatedAt == terminatedAt)&&(identical(other.renewalCount, renewalCount) || other.renewalCount == renewalCount)&&(identical(other.renewalProposedEndDate, renewalProposedEndDate) || other.renewalProposedEndDate == renewalProposedEndDate)&&(identical(other.renewalRequestedBy, renewalRequestedBy) || other.renewalRequestedBy == renewalRequestedBy)&&(identical(other.renewalNote, renewalNote) || other.renewalNote == renewalNote)&&(identical(other.daysUntilExpiry, daysUntilExpiry) || other.daysUntilExpiry == daysUntilExpiry)&&(identical(other.contractPhase, contractPhase) || other.contractPhase == contractPhase)&&(identical(other.canRenew, canRenew) || other.canRenew == canRenew)&&(identical(other.isRenewalPending, isRenewalPending) || other.isRenewalPending == isRenewalPending)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&(identical(other.supplier, supplier) || other.supplier == supplier));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,contractNumber,buyerId,supplierId,tier,status,title,description,productCategory,estimatedMonthlyQty,priceAgreement,deliveryTerms,paymentTerms,specialTerms,startDate,endDate,buyerSignedAt,sellerSignedAt,platformSignedAt,buyerSignerName,buyerSignerTitle,buyerCompanyName,sellerSignerName,sellerSignerTitle,sellerCompanyName,platformSignerName,platformSignerTitle,isFullySigned,requiredSigners,signedCount,const DeepCollectionEquality().hash(signatures),rejectionReason,terminatedAt,renewalCount,renewalProposedEndDate,renewalRequestedBy,renewalNote,daysUntilExpiry,contractPhase,canRenew,isRenewalPending,createdAt,buyer,supplier]);

@override
String toString() {
  return 'PartnershipEntity(id: $id, contractNumber: $contractNumber, buyerId: $buyerId, supplierId: $supplierId, tier: $tier, status: $status, title: $title, description: $description, productCategory: $productCategory, estimatedMonthlyQty: $estimatedMonthlyQty, priceAgreement: $priceAgreement, deliveryTerms: $deliveryTerms, paymentTerms: $paymentTerms, specialTerms: $specialTerms, startDate: $startDate, endDate: $endDate, buyerSignedAt: $buyerSignedAt, sellerSignedAt: $sellerSignedAt, platformSignedAt: $platformSignedAt, buyerSignerName: $buyerSignerName, buyerSignerTitle: $buyerSignerTitle, buyerCompanyName: $buyerCompanyName, sellerSignerName: $sellerSignerName, sellerSignerTitle: $sellerSignerTitle, sellerCompanyName: $sellerCompanyName, platformSignerName: $platformSignerName, platformSignerTitle: $platformSignerTitle, isFullySigned: $isFullySigned, requiredSigners: $requiredSigners, signedCount: $signedCount, signatures: $signatures, rejectionReason: $rejectionReason, terminatedAt: $terminatedAt, renewalCount: $renewalCount, renewalProposedEndDate: $renewalProposedEndDate, renewalRequestedBy: $renewalRequestedBy, renewalNote: $renewalNote, daysUntilExpiry: $daysUntilExpiry, contractPhase: $contractPhase, canRenew: $canRenew, isRenewalPending: $isRenewalPending, createdAt: $createdAt, buyer: $buyer, supplier: $supplier)';
}


}

/// @nodoc
abstract mixin class $PartnershipEntityCopyWith<$Res>  {
  factory $PartnershipEntityCopyWith(PartnershipEntity value, $Res Function(PartnershipEntity) _then) = _$PartnershipEntityCopyWithImpl;
@useResult
$Res call({
 String id, String contractNumber, String buyerId, String supplierId, String tier, String status, String title, String? description, String? productCategory, double? estimatedMonthlyQty, String? priceAgreement, String? deliveryTerms, String? paymentTerms, String? specialTerms, DateTime startDate, DateTime endDate, DateTime? buyerSignedAt, DateTime? sellerSignedAt, DateTime? platformSignedAt, String? buyerSignerName, String? buyerSignerTitle, String? buyerCompanyName, String? sellerSignerName, String? sellerSignerTitle, String? sellerCompanyName, String? platformSignerName, String? platformSignerTitle, bool isFullySigned, int requiredSigners, int signedCount, List<PartnershipSignatureEntity> signatures, String? rejectionReason, DateTime? terminatedAt, int renewalCount, DateTime? renewalProposedEndDate, String? renewalRequestedBy, String? renewalNote, int? daysUntilExpiry, String? contractPhase, bool canRenew, bool isRenewalPending, DateTime createdAt, PartnershipUserEntity buyer, PartnershipUserEntity supplier
});


$PartnershipUserEntityCopyWith<$Res> get buyer;$PartnershipUserEntityCopyWith<$Res> get supplier;

}
/// @nodoc
class _$PartnershipEntityCopyWithImpl<$Res>
    implements $PartnershipEntityCopyWith<$Res> {
  _$PartnershipEntityCopyWithImpl(this._self, this._then);

  final PartnershipEntity _self;
  final $Res Function(PartnershipEntity) _then;

/// Create a copy of PartnershipEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? contractNumber = null,Object? buyerId = null,Object? supplierId = null,Object? tier = null,Object? status = null,Object? title = null,Object? description = freezed,Object? productCategory = freezed,Object? estimatedMonthlyQty = freezed,Object? priceAgreement = freezed,Object? deliveryTerms = freezed,Object? paymentTerms = freezed,Object? specialTerms = freezed,Object? startDate = null,Object? endDate = null,Object? buyerSignedAt = freezed,Object? sellerSignedAt = freezed,Object? platformSignedAt = freezed,Object? buyerSignerName = freezed,Object? buyerSignerTitle = freezed,Object? buyerCompanyName = freezed,Object? sellerSignerName = freezed,Object? sellerSignerTitle = freezed,Object? sellerCompanyName = freezed,Object? platformSignerName = freezed,Object? platformSignerTitle = freezed,Object? isFullySigned = null,Object? requiredSigners = null,Object? signedCount = null,Object? signatures = null,Object? rejectionReason = freezed,Object? terminatedAt = freezed,Object? renewalCount = null,Object? renewalProposedEndDate = freezed,Object? renewalRequestedBy = freezed,Object? renewalNote = freezed,Object? daysUntilExpiry = freezed,Object? contractPhase = freezed,Object? canRenew = null,Object? isRenewalPending = null,Object? createdAt = null,Object? buyer = null,Object? supplier = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,contractNumber: null == contractNumber ? _self.contractNumber : contractNumber // ignore: cast_nullable_to_non_nullable
as String,buyerId: null == buyerId ? _self.buyerId : buyerId // ignore: cast_nullable_to_non_nullable
as String,supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,productCategory: freezed == productCategory ? _self.productCategory : productCategory // ignore: cast_nullable_to_non_nullable
as String?,estimatedMonthlyQty: freezed == estimatedMonthlyQty ? _self.estimatedMonthlyQty : estimatedMonthlyQty // ignore: cast_nullable_to_non_nullable
as double?,priceAgreement: freezed == priceAgreement ? _self.priceAgreement : priceAgreement // ignore: cast_nullable_to_non_nullable
as String?,deliveryTerms: freezed == deliveryTerms ? _self.deliveryTerms : deliveryTerms // ignore: cast_nullable_to_non_nullable
as String?,paymentTerms: freezed == paymentTerms ? _self.paymentTerms : paymentTerms // ignore: cast_nullable_to_non_nullable
as String?,specialTerms: freezed == specialTerms ? _self.specialTerms : specialTerms // ignore: cast_nullable_to_non_nullable
as String?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,buyerSignedAt: freezed == buyerSignedAt ? _self.buyerSignedAt : buyerSignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sellerSignedAt: freezed == sellerSignedAt ? _self.sellerSignedAt : sellerSignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,platformSignedAt: freezed == platformSignedAt ? _self.platformSignedAt : platformSignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,buyerSignerName: freezed == buyerSignerName ? _self.buyerSignerName : buyerSignerName // ignore: cast_nullable_to_non_nullable
as String?,buyerSignerTitle: freezed == buyerSignerTitle ? _self.buyerSignerTitle : buyerSignerTitle // ignore: cast_nullable_to_non_nullable
as String?,buyerCompanyName: freezed == buyerCompanyName ? _self.buyerCompanyName : buyerCompanyName // ignore: cast_nullable_to_non_nullable
as String?,sellerSignerName: freezed == sellerSignerName ? _self.sellerSignerName : sellerSignerName // ignore: cast_nullable_to_non_nullable
as String?,sellerSignerTitle: freezed == sellerSignerTitle ? _self.sellerSignerTitle : sellerSignerTitle // ignore: cast_nullable_to_non_nullable
as String?,sellerCompanyName: freezed == sellerCompanyName ? _self.sellerCompanyName : sellerCompanyName // ignore: cast_nullable_to_non_nullable
as String?,platformSignerName: freezed == platformSignerName ? _self.platformSignerName : platformSignerName // ignore: cast_nullable_to_non_nullable
as String?,platformSignerTitle: freezed == platformSignerTitle ? _self.platformSignerTitle : platformSignerTitle // ignore: cast_nullable_to_non_nullable
as String?,isFullySigned: null == isFullySigned ? _self.isFullySigned : isFullySigned // ignore: cast_nullable_to_non_nullable
as bool,requiredSigners: null == requiredSigners ? _self.requiredSigners : requiredSigners // ignore: cast_nullable_to_non_nullable
as int,signedCount: null == signedCount ? _self.signedCount : signedCount // ignore: cast_nullable_to_non_nullable
as int,signatures: null == signatures ? _self.signatures : signatures // ignore: cast_nullable_to_non_nullable
as List<PartnershipSignatureEntity>,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,terminatedAt: freezed == terminatedAt ? _self.terminatedAt : terminatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,renewalCount: null == renewalCount ? _self.renewalCount : renewalCount // ignore: cast_nullable_to_non_nullable
as int,renewalProposedEndDate: freezed == renewalProposedEndDate ? _self.renewalProposedEndDate : renewalProposedEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,renewalRequestedBy: freezed == renewalRequestedBy ? _self.renewalRequestedBy : renewalRequestedBy // ignore: cast_nullable_to_non_nullable
as String?,renewalNote: freezed == renewalNote ? _self.renewalNote : renewalNote // ignore: cast_nullable_to_non_nullable
as String?,daysUntilExpiry: freezed == daysUntilExpiry ? _self.daysUntilExpiry : daysUntilExpiry // ignore: cast_nullable_to_non_nullable
as int?,contractPhase: freezed == contractPhase ? _self.contractPhase : contractPhase // ignore: cast_nullable_to_non_nullable
as String?,canRenew: null == canRenew ? _self.canRenew : canRenew // ignore: cast_nullable_to_non_nullable
as bool,isRenewalPending: null == isRenewalPending ? _self.isRenewalPending : isRenewalPending // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,buyer: null == buyer ? _self.buyer : buyer // ignore: cast_nullable_to_non_nullable
as PartnershipUserEntity,supplier: null == supplier ? _self.supplier : supplier // ignore: cast_nullable_to_non_nullable
as PartnershipUserEntity,
  ));
}
/// Create a copy of PartnershipEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartnershipUserEntityCopyWith<$Res> get buyer {
  
  return $PartnershipUserEntityCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}/// Create a copy of PartnershipEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartnershipUserEntityCopyWith<$Res> get supplier {
  
  return $PartnershipUserEntityCopyWith<$Res>(_self.supplier, (value) {
    return _then(_self.copyWith(supplier: value));
  });
}
}


/// Adds pattern-matching-related methods to [PartnershipEntity].
extension PartnershipEntityPatterns on PartnershipEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartnershipEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartnershipEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartnershipEntity value)  $default,){
final _that = this;
switch (_that) {
case _PartnershipEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartnershipEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PartnershipEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String contractNumber,  String buyerId,  String supplierId,  String tier,  String status,  String title,  String? description,  String? productCategory,  double? estimatedMonthlyQty,  String? priceAgreement,  String? deliveryTerms,  String? paymentTerms,  String? specialTerms,  DateTime startDate,  DateTime endDate,  DateTime? buyerSignedAt,  DateTime? sellerSignedAt,  DateTime? platformSignedAt,  String? buyerSignerName,  String? buyerSignerTitle,  String? buyerCompanyName,  String? sellerSignerName,  String? sellerSignerTitle,  String? sellerCompanyName,  String? platformSignerName,  String? platformSignerTitle,  bool isFullySigned,  int requiredSigners,  int signedCount,  List<PartnershipSignatureEntity> signatures,  String? rejectionReason,  DateTime? terminatedAt,  int renewalCount,  DateTime? renewalProposedEndDate,  String? renewalRequestedBy,  String? renewalNote,  int? daysUntilExpiry,  String? contractPhase,  bool canRenew,  bool isRenewalPending,  DateTime createdAt,  PartnershipUserEntity buyer,  PartnershipUserEntity supplier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartnershipEntity() when $default != null:
return $default(_that.id,_that.contractNumber,_that.buyerId,_that.supplierId,_that.tier,_that.status,_that.title,_that.description,_that.productCategory,_that.estimatedMonthlyQty,_that.priceAgreement,_that.deliveryTerms,_that.paymentTerms,_that.specialTerms,_that.startDate,_that.endDate,_that.buyerSignedAt,_that.sellerSignedAt,_that.platformSignedAt,_that.buyerSignerName,_that.buyerSignerTitle,_that.buyerCompanyName,_that.sellerSignerName,_that.sellerSignerTitle,_that.sellerCompanyName,_that.platformSignerName,_that.platformSignerTitle,_that.isFullySigned,_that.requiredSigners,_that.signedCount,_that.signatures,_that.rejectionReason,_that.terminatedAt,_that.renewalCount,_that.renewalProposedEndDate,_that.renewalRequestedBy,_that.renewalNote,_that.daysUntilExpiry,_that.contractPhase,_that.canRenew,_that.isRenewalPending,_that.createdAt,_that.buyer,_that.supplier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String contractNumber,  String buyerId,  String supplierId,  String tier,  String status,  String title,  String? description,  String? productCategory,  double? estimatedMonthlyQty,  String? priceAgreement,  String? deliveryTerms,  String? paymentTerms,  String? specialTerms,  DateTime startDate,  DateTime endDate,  DateTime? buyerSignedAt,  DateTime? sellerSignedAt,  DateTime? platformSignedAt,  String? buyerSignerName,  String? buyerSignerTitle,  String? buyerCompanyName,  String? sellerSignerName,  String? sellerSignerTitle,  String? sellerCompanyName,  String? platformSignerName,  String? platformSignerTitle,  bool isFullySigned,  int requiredSigners,  int signedCount,  List<PartnershipSignatureEntity> signatures,  String? rejectionReason,  DateTime? terminatedAt,  int renewalCount,  DateTime? renewalProposedEndDate,  String? renewalRequestedBy,  String? renewalNote,  int? daysUntilExpiry,  String? contractPhase,  bool canRenew,  bool isRenewalPending,  DateTime createdAt,  PartnershipUserEntity buyer,  PartnershipUserEntity supplier)  $default,) {final _that = this;
switch (_that) {
case _PartnershipEntity():
return $default(_that.id,_that.contractNumber,_that.buyerId,_that.supplierId,_that.tier,_that.status,_that.title,_that.description,_that.productCategory,_that.estimatedMonthlyQty,_that.priceAgreement,_that.deliveryTerms,_that.paymentTerms,_that.specialTerms,_that.startDate,_that.endDate,_that.buyerSignedAt,_that.sellerSignedAt,_that.platformSignedAt,_that.buyerSignerName,_that.buyerSignerTitle,_that.buyerCompanyName,_that.sellerSignerName,_that.sellerSignerTitle,_that.sellerCompanyName,_that.platformSignerName,_that.platformSignerTitle,_that.isFullySigned,_that.requiredSigners,_that.signedCount,_that.signatures,_that.rejectionReason,_that.terminatedAt,_that.renewalCount,_that.renewalProposedEndDate,_that.renewalRequestedBy,_that.renewalNote,_that.daysUntilExpiry,_that.contractPhase,_that.canRenew,_that.isRenewalPending,_that.createdAt,_that.buyer,_that.supplier);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String contractNumber,  String buyerId,  String supplierId,  String tier,  String status,  String title,  String? description,  String? productCategory,  double? estimatedMonthlyQty,  String? priceAgreement,  String? deliveryTerms,  String? paymentTerms,  String? specialTerms,  DateTime startDate,  DateTime endDate,  DateTime? buyerSignedAt,  DateTime? sellerSignedAt,  DateTime? platformSignedAt,  String? buyerSignerName,  String? buyerSignerTitle,  String? buyerCompanyName,  String? sellerSignerName,  String? sellerSignerTitle,  String? sellerCompanyName,  String? platformSignerName,  String? platformSignerTitle,  bool isFullySigned,  int requiredSigners,  int signedCount,  List<PartnershipSignatureEntity> signatures,  String? rejectionReason,  DateTime? terminatedAt,  int renewalCount,  DateTime? renewalProposedEndDate,  String? renewalRequestedBy,  String? renewalNote,  int? daysUntilExpiry,  String? contractPhase,  bool canRenew,  bool isRenewalPending,  DateTime createdAt,  PartnershipUserEntity buyer,  PartnershipUserEntity supplier)?  $default,) {final _that = this;
switch (_that) {
case _PartnershipEntity() when $default != null:
return $default(_that.id,_that.contractNumber,_that.buyerId,_that.supplierId,_that.tier,_that.status,_that.title,_that.description,_that.productCategory,_that.estimatedMonthlyQty,_that.priceAgreement,_that.deliveryTerms,_that.paymentTerms,_that.specialTerms,_that.startDate,_that.endDate,_that.buyerSignedAt,_that.sellerSignedAt,_that.platformSignedAt,_that.buyerSignerName,_that.buyerSignerTitle,_that.buyerCompanyName,_that.sellerSignerName,_that.sellerSignerTitle,_that.sellerCompanyName,_that.platformSignerName,_that.platformSignerTitle,_that.isFullySigned,_that.requiredSigners,_that.signedCount,_that.signatures,_that.rejectionReason,_that.terminatedAt,_that.renewalCount,_that.renewalProposedEndDate,_that.renewalRequestedBy,_that.renewalNote,_that.daysUntilExpiry,_that.contractPhase,_that.canRenew,_that.isRenewalPending,_that.createdAt,_that.buyer,_that.supplier);case _:
  return null;

}
}

}

/// @nodoc


class _PartnershipEntity extends PartnershipEntity {
  const _PartnershipEntity({required this.id, required this.contractNumber, required this.buyerId, required this.supplierId, required this.tier, required this.status, required this.title, this.description, this.productCategory, this.estimatedMonthlyQty, this.priceAgreement, this.deliveryTerms, this.paymentTerms, this.specialTerms, required this.startDate, required this.endDate, this.buyerSignedAt, this.sellerSignedAt, this.platformSignedAt, this.buyerSignerName, this.buyerSignerTitle, this.buyerCompanyName, this.sellerSignerName, this.sellerSignerTitle, this.sellerCompanyName, this.platformSignerName, this.platformSignerTitle, this.isFullySigned = false, this.requiredSigners = 3, this.signedCount = 0, final  List<PartnershipSignatureEntity> signatures = const [], this.rejectionReason, this.terminatedAt, this.renewalCount = 0, this.renewalProposedEndDate, this.renewalRequestedBy, this.renewalNote, this.daysUntilExpiry, this.contractPhase, this.canRenew = false, this.isRenewalPending = false, required this.createdAt, required this.buyer, required this.supplier}): _signatures = signatures,super._();
  

@override final  String id;
@override final  String contractNumber;
@override final  String buyerId;
@override final  String supplierId;
@override final  String tier;
@override final  String status;
@override final  String title;
@override final  String? description;
@override final  String? productCategory;
@override final  double? estimatedMonthlyQty;
@override final  String? priceAgreement;
@override final  String? deliveryTerms;
@override final  String? paymentTerms;
@override final  String? specialTerms;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  DateTime? buyerSignedAt;
@override final  DateTime? sellerSignedAt;
@override final  DateTime? platformSignedAt;
@override final  String? buyerSignerName;
@override final  String? buyerSignerTitle;
@override final  String? buyerCompanyName;
@override final  String? sellerSignerName;
@override final  String? sellerSignerTitle;
@override final  String? sellerCompanyName;
@override final  String? platformSignerName;
@override final  String? platformSignerTitle;
@override@JsonKey() final  bool isFullySigned;
@override@JsonKey() final  int requiredSigners;
@override@JsonKey() final  int signedCount;
 final  List<PartnershipSignatureEntity> _signatures;
@override@JsonKey() List<PartnershipSignatureEntity> get signatures {
  if (_signatures is EqualUnmodifiableListView) return _signatures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_signatures);
}

@override final  String? rejectionReason;
@override final  DateTime? terminatedAt;
@override@JsonKey() final  int renewalCount;
@override final  DateTime? renewalProposedEndDate;
@override final  String? renewalRequestedBy;
@override final  String? renewalNote;
@override final  int? daysUntilExpiry;
@override final  String? contractPhase;
@override@JsonKey() final  bool canRenew;
@override@JsonKey() final  bool isRenewalPending;
@override final  DateTime createdAt;
@override final  PartnershipUserEntity buyer;
@override final  PartnershipUserEntity supplier;

/// Create a copy of PartnershipEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartnershipEntityCopyWith<_PartnershipEntity> get copyWith => __$PartnershipEntityCopyWithImpl<_PartnershipEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartnershipEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.contractNumber, contractNumber) || other.contractNumber == contractNumber)&&(identical(other.buyerId, buyerId) || other.buyerId == buyerId)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.status, status) || other.status == status)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.productCategory, productCategory) || other.productCategory == productCategory)&&(identical(other.estimatedMonthlyQty, estimatedMonthlyQty) || other.estimatedMonthlyQty == estimatedMonthlyQty)&&(identical(other.priceAgreement, priceAgreement) || other.priceAgreement == priceAgreement)&&(identical(other.deliveryTerms, deliveryTerms) || other.deliveryTerms == deliveryTerms)&&(identical(other.paymentTerms, paymentTerms) || other.paymentTerms == paymentTerms)&&(identical(other.specialTerms, specialTerms) || other.specialTerms == specialTerms)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.buyerSignedAt, buyerSignedAt) || other.buyerSignedAt == buyerSignedAt)&&(identical(other.sellerSignedAt, sellerSignedAt) || other.sellerSignedAt == sellerSignedAt)&&(identical(other.platformSignedAt, platformSignedAt) || other.platformSignedAt == platformSignedAt)&&(identical(other.buyerSignerName, buyerSignerName) || other.buyerSignerName == buyerSignerName)&&(identical(other.buyerSignerTitle, buyerSignerTitle) || other.buyerSignerTitle == buyerSignerTitle)&&(identical(other.buyerCompanyName, buyerCompanyName) || other.buyerCompanyName == buyerCompanyName)&&(identical(other.sellerSignerName, sellerSignerName) || other.sellerSignerName == sellerSignerName)&&(identical(other.sellerSignerTitle, sellerSignerTitle) || other.sellerSignerTitle == sellerSignerTitle)&&(identical(other.sellerCompanyName, sellerCompanyName) || other.sellerCompanyName == sellerCompanyName)&&(identical(other.platformSignerName, platformSignerName) || other.platformSignerName == platformSignerName)&&(identical(other.platformSignerTitle, platformSignerTitle) || other.platformSignerTitle == platformSignerTitle)&&(identical(other.isFullySigned, isFullySigned) || other.isFullySigned == isFullySigned)&&(identical(other.requiredSigners, requiredSigners) || other.requiredSigners == requiredSigners)&&(identical(other.signedCount, signedCount) || other.signedCount == signedCount)&&const DeepCollectionEquality().equals(other._signatures, _signatures)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.terminatedAt, terminatedAt) || other.terminatedAt == terminatedAt)&&(identical(other.renewalCount, renewalCount) || other.renewalCount == renewalCount)&&(identical(other.renewalProposedEndDate, renewalProposedEndDate) || other.renewalProposedEndDate == renewalProposedEndDate)&&(identical(other.renewalRequestedBy, renewalRequestedBy) || other.renewalRequestedBy == renewalRequestedBy)&&(identical(other.renewalNote, renewalNote) || other.renewalNote == renewalNote)&&(identical(other.daysUntilExpiry, daysUntilExpiry) || other.daysUntilExpiry == daysUntilExpiry)&&(identical(other.contractPhase, contractPhase) || other.contractPhase == contractPhase)&&(identical(other.canRenew, canRenew) || other.canRenew == canRenew)&&(identical(other.isRenewalPending, isRenewalPending) || other.isRenewalPending == isRenewalPending)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&(identical(other.supplier, supplier) || other.supplier == supplier));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,contractNumber,buyerId,supplierId,tier,status,title,description,productCategory,estimatedMonthlyQty,priceAgreement,deliveryTerms,paymentTerms,specialTerms,startDate,endDate,buyerSignedAt,sellerSignedAt,platformSignedAt,buyerSignerName,buyerSignerTitle,buyerCompanyName,sellerSignerName,sellerSignerTitle,sellerCompanyName,platformSignerName,platformSignerTitle,isFullySigned,requiredSigners,signedCount,const DeepCollectionEquality().hash(_signatures),rejectionReason,terminatedAt,renewalCount,renewalProposedEndDate,renewalRequestedBy,renewalNote,daysUntilExpiry,contractPhase,canRenew,isRenewalPending,createdAt,buyer,supplier]);

@override
String toString() {
  return 'PartnershipEntity(id: $id, contractNumber: $contractNumber, buyerId: $buyerId, supplierId: $supplierId, tier: $tier, status: $status, title: $title, description: $description, productCategory: $productCategory, estimatedMonthlyQty: $estimatedMonthlyQty, priceAgreement: $priceAgreement, deliveryTerms: $deliveryTerms, paymentTerms: $paymentTerms, specialTerms: $specialTerms, startDate: $startDate, endDate: $endDate, buyerSignedAt: $buyerSignedAt, sellerSignedAt: $sellerSignedAt, platformSignedAt: $platformSignedAt, buyerSignerName: $buyerSignerName, buyerSignerTitle: $buyerSignerTitle, buyerCompanyName: $buyerCompanyName, sellerSignerName: $sellerSignerName, sellerSignerTitle: $sellerSignerTitle, sellerCompanyName: $sellerCompanyName, platformSignerName: $platformSignerName, platformSignerTitle: $platformSignerTitle, isFullySigned: $isFullySigned, requiredSigners: $requiredSigners, signedCount: $signedCount, signatures: $signatures, rejectionReason: $rejectionReason, terminatedAt: $terminatedAt, renewalCount: $renewalCount, renewalProposedEndDate: $renewalProposedEndDate, renewalRequestedBy: $renewalRequestedBy, renewalNote: $renewalNote, daysUntilExpiry: $daysUntilExpiry, contractPhase: $contractPhase, canRenew: $canRenew, isRenewalPending: $isRenewalPending, createdAt: $createdAt, buyer: $buyer, supplier: $supplier)';
}


}

/// @nodoc
abstract mixin class _$PartnershipEntityCopyWith<$Res> implements $PartnershipEntityCopyWith<$Res> {
  factory _$PartnershipEntityCopyWith(_PartnershipEntity value, $Res Function(_PartnershipEntity) _then) = __$PartnershipEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String contractNumber, String buyerId, String supplierId, String tier, String status, String title, String? description, String? productCategory, double? estimatedMonthlyQty, String? priceAgreement, String? deliveryTerms, String? paymentTerms, String? specialTerms, DateTime startDate, DateTime endDate, DateTime? buyerSignedAt, DateTime? sellerSignedAt, DateTime? platformSignedAt, String? buyerSignerName, String? buyerSignerTitle, String? buyerCompanyName, String? sellerSignerName, String? sellerSignerTitle, String? sellerCompanyName, String? platformSignerName, String? platformSignerTitle, bool isFullySigned, int requiredSigners, int signedCount, List<PartnershipSignatureEntity> signatures, String? rejectionReason, DateTime? terminatedAt, int renewalCount, DateTime? renewalProposedEndDate, String? renewalRequestedBy, String? renewalNote, int? daysUntilExpiry, String? contractPhase, bool canRenew, bool isRenewalPending, DateTime createdAt, PartnershipUserEntity buyer, PartnershipUserEntity supplier
});


@override $PartnershipUserEntityCopyWith<$Res> get buyer;@override $PartnershipUserEntityCopyWith<$Res> get supplier;

}
/// @nodoc
class __$PartnershipEntityCopyWithImpl<$Res>
    implements _$PartnershipEntityCopyWith<$Res> {
  __$PartnershipEntityCopyWithImpl(this._self, this._then);

  final _PartnershipEntity _self;
  final $Res Function(_PartnershipEntity) _then;

/// Create a copy of PartnershipEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? contractNumber = null,Object? buyerId = null,Object? supplierId = null,Object? tier = null,Object? status = null,Object? title = null,Object? description = freezed,Object? productCategory = freezed,Object? estimatedMonthlyQty = freezed,Object? priceAgreement = freezed,Object? deliveryTerms = freezed,Object? paymentTerms = freezed,Object? specialTerms = freezed,Object? startDate = null,Object? endDate = null,Object? buyerSignedAt = freezed,Object? sellerSignedAt = freezed,Object? platformSignedAt = freezed,Object? buyerSignerName = freezed,Object? buyerSignerTitle = freezed,Object? buyerCompanyName = freezed,Object? sellerSignerName = freezed,Object? sellerSignerTitle = freezed,Object? sellerCompanyName = freezed,Object? platformSignerName = freezed,Object? platformSignerTitle = freezed,Object? isFullySigned = null,Object? requiredSigners = null,Object? signedCount = null,Object? signatures = null,Object? rejectionReason = freezed,Object? terminatedAt = freezed,Object? renewalCount = null,Object? renewalProposedEndDate = freezed,Object? renewalRequestedBy = freezed,Object? renewalNote = freezed,Object? daysUntilExpiry = freezed,Object? contractPhase = freezed,Object? canRenew = null,Object? isRenewalPending = null,Object? createdAt = null,Object? buyer = null,Object? supplier = null,}) {
  return _then(_PartnershipEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,contractNumber: null == contractNumber ? _self.contractNumber : contractNumber // ignore: cast_nullable_to_non_nullable
as String,buyerId: null == buyerId ? _self.buyerId : buyerId // ignore: cast_nullable_to_non_nullable
as String,supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,productCategory: freezed == productCategory ? _self.productCategory : productCategory // ignore: cast_nullable_to_non_nullable
as String?,estimatedMonthlyQty: freezed == estimatedMonthlyQty ? _self.estimatedMonthlyQty : estimatedMonthlyQty // ignore: cast_nullable_to_non_nullable
as double?,priceAgreement: freezed == priceAgreement ? _self.priceAgreement : priceAgreement // ignore: cast_nullable_to_non_nullable
as String?,deliveryTerms: freezed == deliveryTerms ? _self.deliveryTerms : deliveryTerms // ignore: cast_nullable_to_non_nullable
as String?,paymentTerms: freezed == paymentTerms ? _self.paymentTerms : paymentTerms // ignore: cast_nullable_to_non_nullable
as String?,specialTerms: freezed == specialTerms ? _self.specialTerms : specialTerms // ignore: cast_nullable_to_non_nullable
as String?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,buyerSignedAt: freezed == buyerSignedAt ? _self.buyerSignedAt : buyerSignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sellerSignedAt: freezed == sellerSignedAt ? _self.sellerSignedAt : sellerSignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,platformSignedAt: freezed == platformSignedAt ? _self.platformSignedAt : platformSignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,buyerSignerName: freezed == buyerSignerName ? _self.buyerSignerName : buyerSignerName // ignore: cast_nullable_to_non_nullable
as String?,buyerSignerTitle: freezed == buyerSignerTitle ? _self.buyerSignerTitle : buyerSignerTitle // ignore: cast_nullable_to_non_nullable
as String?,buyerCompanyName: freezed == buyerCompanyName ? _self.buyerCompanyName : buyerCompanyName // ignore: cast_nullable_to_non_nullable
as String?,sellerSignerName: freezed == sellerSignerName ? _self.sellerSignerName : sellerSignerName // ignore: cast_nullable_to_non_nullable
as String?,sellerSignerTitle: freezed == sellerSignerTitle ? _self.sellerSignerTitle : sellerSignerTitle // ignore: cast_nullable_to_non_nullable
as String?,sellerCompanyName: freezed == sellerCompanyName ? _self.sellerCompanyName : sellerCompanyName // ignore: cast_nullable_to_non_nullable
as String?,platformSignerName: freezed == platformSignerName ? _self.platformSignerName : platformSignerName // ignore: cast_nullable_to_non_nullable
as String?,platformSignerTitle: freezed == platformSignerTitle ? _self.platformSignerTitle : platformSignerTitle // ignore: cast_nullable_to_non_nullable
as String?,isFullySigned: null == isFullySigned ? _self.isFullySigned : isFullySigned // ignore: cast_nullable_to_non_nullable
as bool,requiredSigners: null == requiredSigners ? _self.requiredSigners : requiredSigners // ignore: cast_nullable_to_non_nullable
as int,signedCount: null == signedCount ? _self.signedCount : signedCount // ignore: cast_nullable_to_non_nullable
as int,signatures: null == signatures ? _self._signatures : signatures // ignore: cast_nullable_to_non_nullable
as List<PartnershipSignatureEntity>,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,terminatedAt: freezed == terminatedAt ? _self.terminatedAt : terminatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,renewalCount: null == renewalCount ? _self.renewalCount : renewalCount // ignore: cast_nullable_to_non_nullable
as int,renewalProposedEndDate: freezed == renewalProposedEndDate ? _self.renewalProposedEndDate : renewalProposedEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,renewalRequestedBy: freezed == renewalRequestedBy ? _self.renewalRequestedBy : renewalRequestedBy // ignore: cast_nullable_to_non_nullable
as String?,renewalNote: freezed == renewalNote ? _self.renewalNote : renewalNote // ignore: cast_nullable_to_non_nullable
as String?,daysUntilExpiry: freezed == daysUntilExpiry ? _self.daysUntilExpiry : daysUntilExpiry // ignore: cast_nullable_to_non_nullable
as int?,contractPhase: freezed == contractPhase ? _self.contractPhase : contractPhase // ignore: cast_nullable_to_non_nullable
as String?,canRenew: null == canRenew ? _self.canRenew : canRenew // ignore: cast_nullable_to_non_nullable
as bool,isRenewalPending: null == isRenewalPending ? _self.isRenewalPending : isRenewalPending // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,buyer: null == buyer ? _self.buyer : buyer // ignore: cast_nullable_to_non_nullable
as PartnershipUserEntity,supplier: null == supplier ? _self.supplier : supplier // ignore: cast_nullable_to_non_nullable
as PartnershipUserEntity,
  ));
}

/// Create a copy of PartnershipEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartnershipUserEntityCopyWith<$Res> get buyer {
  
  return $PartnershipUserEntityCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}/// Create a copy of PartnershipEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartnershipUserEntityCopyWith<$Res> get supplier {
  
  return $PartnershipUserEntityCopyWith<$Res>(_self.supplier, (value) {
    return _then(_self.copyWith(supplier: value));
  });
}
}

// dart format on
