// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'partnership_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PartnershipUserModel {

 String get id; String get fullName; String? get avatarUrl; String get role; String? get province; String? get regency; bool get isVerified; String? get companyName; String? get businessType;
/// Create a copy of PartnershipUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartnershipUserModelCopyWith<PartnershipUserModel> get copyWith => _$PartnershipUserModelCopyWithImpl<PartnershipUserModel>(this as PartnershipUserModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartnershipUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.businessType, businessType) || other.businessType == businessType));
}


@override
int get hashCode => Object.hash(runtimeType,id,fullName,avatarUrl,role,province,regency,isVerified,companyName,businessType);

@override
String toString() {
  return 'PartnershipUserModel(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, role: $role, province: $province, regency: $regency, isVerified: $isVerified, companyName: $companyName, businessType: $businessType)';
}


}

/// @nodoc
abstract mixin class $PartnershipUserModelCopyWith<$Res>  {
  factory $PartnershipUserModelCopyWith(PartnershipUserModel value, $Res Function(PartnershipUserModel) _then) = _$PartnershipUserModelCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String? avatarUrl, String role, String? province, String? regency, bool isVerified, String? companyName, String? businessType
});




}
/// @nodoc
class _$PartnershipUserModelCopyWithImpl<$Res>
    implements $PartnershipUserModelCopyWith<$Res> {
  _$PartnershipUserModelCopyWithImpl(this._self, this._then);

  final PartnershipUserModel _self;
  final $Res Function(PartnershipUserModel) _then;

/// Create a copy of PartnershipUserModel
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


/// Adds pattern-matching-related methods to [PartnershipUserModel].
extension PartnershipUserModelPatterns on PartnershipUserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartnershipUserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartnershipUserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartnershipUserModel value)  $default,){
final _that = this;
switch (_that) {
case _PartnershipUserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartnershipUserModel value)?  $default,){
final _that = this;
switch (_that) {
case _PartnershipUserModel() when $default != null:
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
case _PartnershipUserModel() when $default != null:
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
case _PartnershipUserModel():
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
case _PartnershipUserModel() when $default != null:
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.role,_that.province,_that.regency,_that.isVerified,_that.companyName,_that.businessType);case _:
  return null;

}
}

}

/// @nodoc


class _PartnershipUserModel implements PartnershipUserModel {
  const _PartnershipUserModel({required this.id, required this.fullName, this.avatarUrl, required this.role, this.province, this.regency, this.isVerified = false, this.companyName, this.businessType});
  

@override final  String id;
@override final  String fullName;
@override final  String? avatarUrl;
@override final  String role;
@override final  String? province;
@override final  String? regency;
@override@JsonKey() final  bool isVerified;
@override final  String? companyName;
@override final  String? businessType;

/// Create a copy of PartnershipUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartnershipUserModelCopyWith<_PartnershipUserModel> get copyWith => __$PartnershipUserModelCopyWithImpl<_PartnershipUserModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartnershipUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.businessType, businessType) || other.businessType == businessType));
}


@override
int get hashCode => Object.hash(runtimeType,id,fullName,avatarUrl,role,province,regency,isVerified,companyName,businessType);

@override
String toString() {
  return 'PartnershipUserModel(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, role: $role, province: $province, regency: $regency, isVerified: $isVerified, companyName: $companyName, businessType: $businessType)';
}


}

/// @nodoc
abstract mixin class _$PartnershipUserModelCopyWith<$Res> implements $PartnershipUserModelCopyWith<$Res> {
  factory _$PartnershipUserModelCopyWith(_PartnershipUserModel value, $Res Function(_PartnershipUserModel) _then) = __$PartnershipUserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String? avatarUrl, String role, String? province, String? regency, bool isVerified, String? companyName, String? businessType
});




}
/// @nodoc
class __$PartnershipUserModelCopyWithImpl<$Res>
    implements _$PartnershipUserModelCopyWith<$Res> {
  __$PartnershipUserModelCopyWithImpl(this._self, this._then);

  final _PartnershipUserModel _self;
  final $Res Function(_PartnershipUserModel) _then;

/// Create a copy of PartnershipUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? avatarUrl = freezed,Object? role = null,Object? province = freezed,Object? regency = freezed,Object? isVerified = null,Object? companyName = freezed,Object? businessType = freezed,}) {
  return _then(_PartnershipUserModel(
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
mixin _$PartnershipSignatureModel {

 String get party; String get label; DateTime? get signedAt; String? get signerName; String? get signerTitle; String? get companyName;
/// Create a copy of PartnershipSignatureModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartnershipSignatureModelCopyWith<PartnershipSignatureModel> get copyWith => _$PartnershipSignatureModelCopyWithImpl<PartnershipSignatureModel>(this as PartnershipSignatureModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartnershipSignatureModel&&(identical(other.party, party) || other.party == party)&&(identical(other.label, label) || other.label == label)&&(identical(other.signedAt, signedAt) || other.signedAt == signedAt)&&(identical(other.signerName, signerName) || other.signerName == signerName)&&(identical(other.signerTitle, signerTitle) || other.signerTitle == signerTitle)&&(identical(other.companyName, companyName) || other.companyName == companyName));
}


@override
int get hashCode => Object.hash(runtimeType,party,label,signedAt,signerName,signerTitle,companyName);

@override
String toString() {
  return 'PartnershipSignatureModel(party: $party, label: $label, signedAt: $signedAt, signerName: $signerName, signerTitle: $signerTitle, companyName: $companyName)';
}


}

/// @nodoc
abstract mixin class $PartnershipSignatureModelCopyWith<$Res>  {
  factory $PartnershipSignatureModelCopyWith(PartnershipSignatureModel value, $Res Function(PartnershipSignatureModel) _then) = _$PartnershipSignatureModelCopyWithImpl;
@useResult
$Res call({
 String party, String label, DateTime? signedAt, String? signerName, String? signerTitle, String? companyName
});




}
/// @nodoc
class _$PartnershipSignatureModelCopyWithImpl<$Res>
    implements $PartnershipSignatureModelCopyWith<$Res> {
  _$PartnershipSignatureModelCopyWithImpl(this._self, this._then);

  final PartnershipSignatureModel _self;
  final $Res Function(PartnershipSignatureModel) _then;

/// Create a copy of PartnershipSignatureModel
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


/// Adds pattern-matching-related methods to [PartnershipSignatureModel].
extension PartnershipSignatureModelPatterns on PartnershipSignatureModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartnershipSignatureModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartnershipSignatureModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartnershipSignatureModel value)  $default,){
final _that = this;
switch (_that) {
case _PartnershipSignatureModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartnershipSignatureModel value)?  $default,){
final _that = this;
switch (_that) {
case _PartnershipSignatureModel() when $default != null:
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
case _PartnershipSignatureModel() when $default != null:
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
case _PartnershipSignatureModel():
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
case _PartnershipSignatureModel() when $default != null:
return $default(_that.party,_that.label,_that.signedAt,_that.signerName,_that.signerTitle,_that.companyName);case _:
  return null;

}
}

}

/// @nodoc


class _PartnershipSignatureModel implements PartnershipSignatureModel {
  const _PartnershipSignatureModel({required this.party, required this.label, this.signedAt, this.signerName, this.signerTitle, this.companyName});
  

@override final  String party;
@override final  String label;
@override final  DateTime? signedAt;
@override final  String? signerName;
@override final  String? signerTitle;
@override final  String? companyName;

/// Create a copy of PartnershipSignatureModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartnershipSignatureModelCopyWith<_PartnershipSignatureModel> get copyWith => __$PartnershipSignatureModelCopyWithImpl<_PartnershipSignatureModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartnershipSignatureModel&&(identical(other.party, party) || other.party == party)&&(identical(other.label, label) || other.label == label)&&(identical(other.signedAt, signedAt) || other.signedAt == signedAt)&&(identical(other.signerName, signerName) || other.signerName == signerName)&&(identical(other.signerTitle, signerTitle) || other.signerTitle == signerTitle)&&(identical(other.companyName, companyName) || other.companyName == companyName));
}


@override
int get hashCode => Object.hash(runtimeType,party,label,signedAt,signerName,signerTitle,companyName);

@override
String toString() {
  return 'PartnershipSignatureModel(party: $party, label: $label, signedAt: $signedAt, signerName: $signerName, signerTitle: $signerTitle, companyName: $companyName)';
}


}

/// @nodoc
abstract mixin class _$PartnershipSignatureModelCopyWith<$Res> implements $PartnershipSignatureModelCopyWith<$Res> {
  factory _$PartnershipSignatureModelCopyWith(_PartnershipSignatureModel value, $Res Function(_PartnershipSignatureModel) _then) = __$PartnershipSignatureModelCopyWithImpl;
@override @useResult
$Res call({
 String party, String label, DateTime? signedAt, String? signerName, String? signerTitle, String? companyName
});




}
/// @nodoc
class __$PartnershipSignatureModelCopyWithImpl<$Res>
    implements _$PartnershipSignatureModelCopyWith<$Res> {
  __$PartnershipSignatureModelCopyWithImpl(this._self, this._then);

  final _PartnershipSignatureModel _self;
  final $Res Function(_PartnershipSignatureModel) _then;

/// Create a copy of PartnershipSignatureModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? party = null,Object? label = null,Object? signedAt = freezed,Object? signerName = freezed,Object? signerTitle = freezed,Object? companyName = freezed,}) {
  return _then(_PartnershipSignatureModel(
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
mixin _$PartnershipModel {

 String get id; String get contractNumber; String get buyerId; String get supplierId; String get tier; String get status; String get title; String? get description; String? get productCategory; double? get estimatedMonthlyQty; String? get priceAgreement; String? get deliveryTerms; String? get paymentTerms; String? get specialTerms; DateTime get startDate; DateTime get endDate; DateTime? get buyerSignedAt; DateTime? get sellerSignedAt; DateTime? get platformSignedAt; String? get buyerSignerName; String? get buyerSignerTitle; String? get buyerCompanyName; String? get sellerSignerName; String? get sellerSignerTitle; String? get sellerCompanyName; String? get platformSignerName; String? get platformSignerTitle; bool get isFullySigned; int get requiredSigners; int get signedCount; List<PartnershipSignatureModel> get signatures; String? get rejectionReason; DateTime? get terminatedAt; String? get terminatedBy; int get renewalCount; DateTime? get renewalProposedEndDate; String? get renewalRequestedBy; DateTime? get renewalRequestedAt; String? get renewalNote; int? get daysUntilExpiry; String? get contractPhase; bool get canRenew; bool get isRenewalPending; DateTime get createdAt; DateTime get updatedAt; PartnershipUserModel get buyer; PartnershipUserModel get supplier;
/// Create a copy of PartnershipModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartnershipModelCopyWith<PartnershipModel> get copyWith => _$PartnershipModelCopyWithImpl<PartnershipModel>(this as PartnershipModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartnershipModel&&(identical(other.id, id) || other.id == id)&&(identical(other.contractNumber, contractNumber) || other.contractNumber == contractNumber)&&(identical(other.buyerId, buyerId) || other.buyerId == buyerId)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.status, status) || other.status == status)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.productCategory, productCategory) || other.productCategory == productCategory)&&(identical(other.estimatedMonthlyQty, estimatedMonthlyQty) || other.estimatedMonthlyQty == estimatedMonthlyQty)&&(identical(other.priceAgreement, priceAgreement) || other.priceAgreement == priceAgreement)&&(identical(other.deliveryTerms, deliveryTerms) || other.deliveryTerms == deliveryTerms)&&(identical(other.paymentTerms, paymentTerms) || other.paymentTerms == paymentTerms)&&(identical(other.specialTerms, specialTerms) || other.specialTerms == specialTerms)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.buyerSignedAt, buyerSignedAt) || other.buyerSignedAt == buyerSignedAt)&&(identical(other.sellerSignedAt, sellerSignedAt) || other.sellerSignedAt == sellerSignedAt)&&(identical(other.platformSignedAt, platformSignedAt) || other.platformSignedAt == platformSignedAt)&&(identical(other.buyerSignerName, buyerSignerName) || other.buyerSignerName == buyerSignerName)&&(identical(other.buyerSignerTitle, buyerSignerTitle) || other.buyerSignerTitle == buyerSignerTitle)&&(identical(other.buyerCompanyName, buyerCompanyName) || other.buyerCompanyName == buyerCompanyName)&&(identical(other.sellerSignerName, sellerSignerName) || other.sellerSignerName == sellerSignerName)&&(identical(other.sellerSignerTitle, sellerSignerTitle) || other.sellerSignerTitle == sellerSignerTitle)&&(identical(other.sellerCompanyName, sellerCompanyName) || other.sellerCompanyName == sellerCompanyName)&&(identical(other.platformSignerName, platformSignerName) || other.platformSignerName == platformSignerName)&&(identical(other.platformSignerTitle, platformSignerTitle) || other.platformSignerTitle == platformSignerTitle)&&(identical(other.isFullySigned, isFullySigned) || other.isFullySigned == isFullySigned)&&(identical(other.requiredSigners, requiredSigners) || other.requiredSigners == requiredSigners)&&(identical(other.signedCount, signedCount) || other.signedCount == signedCount)&&const DeepCollectionEquality().equals(other.signatures, signatures)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.terminatedAt, terminatedAt) || other.terminatedAt == terminatedAt)&&(identical(other.terminatedBy, terminatedBy) || other.terminatedBy == terminatedBy)&&(identical(other.renewalCount, renewalCount) || other.renewalCount == renewalCount)&&(identical(other.renewalProposedEndDate, renewalProposedEndDate) || other.renewalProposedEndDate == renewalProposedEndDate)&&(identical(other.renewalRequestedBy, renewalRequestedBy) || other.renewalRequestedBy == renewalRequestedBy)&&(identical(other.renewalRequestedAt, renewalRequestedAt) || other.renewalRequestedAt == renewalRequestedAt)&&(identical(other.renewalNote, renewalNote) || other.renewalNote == renewalNote)&&(identical(other.daysUntilExpiry, daysUntilExpiry) || other.daysUntilExpiry == daysUntilExpiry)&&(identical(other.contractPhase, contractPhase) || other.contractPhase == contractPhase)&&(identical(other.canRenew, canRenew) || other.canRenew == canRenew)&&(identical(other.isRenewalPending, isRenewalPending) || other.isRenewalPending == isRenewalPending)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&(identical(other.supplier, supplier) || other.supplier == supplier));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,contractNumber,buyerId,supplierId,tier,status,title,description,productCategory,estimatedMonthlyQty,priceAgreement,deliveryTerms,paymentTerms,specialTerms,startDate,endDate,buyerSignedAt,sellerSignedAt,platformSignedAt,buyerSignerName,buyerSignerTitle,buyerCompanyName,sellerSignerName,sellerSignerTitle,sellerCompanyName,platformSignerName,platformSignerTitle,isFullySigned,requiredSigners,signedCount,const DeepCollectionEquality().hash(signatures),rejectionReason,terminatedAt,terminatedBy,renewalCount,renewalProposedEndDate,renewalRequestedBy,renewalRequestedAt,renewalNote,daysUntilExpiry,contractPhase,canRenew,isRenewalPending,createdAt,updatedAt,buyer,supplier]);

@override
String toString() {
  return 'PartnershipModel(id: $id, contractNumber: $contractNumber, buyerId: $buyerId, supplierId: $supplierId, tier: $tier, status: $status, title: $title, description: $description, productCategory: $productCategory, estimatedMonthlyQty: $estimatedMonthlyQty, priceAgreement: $priceAgreement, deliveryTerms: $deliveryTerms, paymentTerms: $paymentTerms, specialTerms: $specialTerms, startDate: $startDate, endDate: $endDate, buyerSignedAt: $buyerSignedAt, sellerSignedAt: $sellerSignedAt, platformSignedAt: $platformSignedAt, buyerSignerName: $buyerSignerName, buyerSignerTitle: $buyerSignerTitle, buyerCompanyName: $buyerCompanyName, sellerSignerName: $sellerSignerName, sellerSignerTitle: $sellerSignerTitle, sellerCompanyName: $sellerCompanyName, platformSignerName: $platformSignerName, platformSignerTitle: $platformSignerTitle, isFullySigned: $isFullySigned, requiredSigners: $requiredSigners, signedCount: $signedCount, signatures: $signatures, rejectionReason: $rejectionReason, terminatedAt: $terminatedAt, terminatedBy: $terminatedBy, renewalCount: $renewalCount, renewalProposedEndDate: $renewalProposedEndDate, renewalRequestedBy: $renewalRequestedBy, renewalRequestedAt: $renewalRequestedAt, renewalNote: $renewalNote, daysUntilExpiry: $daysUntilExpiry, contractPhase: $contractPhase, canRenew: $canRenew, isRenewalPending: $isRenewalPending, createdAt: $createdAt, updatedAt: $updatedAt, buyer: $buyer, supplier: $supplier)';
}


}

/// @nodoc
abstract mixin class $PartnershipModelCopyWith<$Res>  {
  factory $PartnershipModelCopyWith(PartnershipModel value, $Res Function(PartnershipModel) _then) = _$PartnershipModelCopyWithImpl;
@useResult
$Res call({
 String id, String contractNumber, String buyerId, String supplierId, String tier, String status, String title, String? description, String? productCategory, double? estimatedMonthlyQty, String? priceAgreement, String? deliveryTerms, String? paymentTerms, String? specialTerms, DateTime startDate, DateTime endDate, DateTime? buyerSignedAt, DateTime? sellerSignedAt, DateTime? platformSignedAt, String? buyerSignerName, String? buyerSignerTitle, String? buyerCompanyName, String? sellerSignerName, String? sellerSignerTitle, String? sellerCompanyName, String? platformSignerName, String? platformSignerTitle, bool isFullySigned, int requiredSigners, int signedCount, List<PartnershipSignatureModel> signatures, String? rejectionReason, DateTime? terminatedAt, String? terminatedBy, int renewalCount, DateTime? renewalProposedEndDate, String? renewalRequestedBy, DateTime? renewalRequestedAt, String? renewalNote, int? daysUntilExpiry, String? contractPhase, bool canRenew, bool isRenewalPending, DateTime createdAt, DateTime updatedAt, PartnershipUserModel buyer, PartnershipUserModel supplier
});


$PartnershipUserModelCopyWith<$Res> get buyer;$PartnershipUserModelCopyWith<$Res> get supplier;

}
/// @nodoc
class _$PartnershipModelCopyWithImpl<$Res>
    implements $PartnershipModelCopyWith<$Res> {
  _$PartnershipModelCopyWithImpl(this._self, this._then);

  final PartnershipModel _self;
  final $Res Function(PartnershipModel) _then;

/// Create a copy of PartnershipModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? contractNumber = null,Object? buyerId = null,Object? supplierId = null,Object? tier = null,Object? status = null,Object? title = null,Object? description = freezed,Object? productCategory = freezed,Object? estimatedMonthlyQty = freezed,Object? priceAgreement = freezed,Object? deliveryTerms = freezed,Object? paymentTerms = freezed,Object? specialTerms = freezed,Object? startDate = null,Object? endDate = null,Object? buyerSignedAt = freezed,Object? sellerSignedAt = freezed,Object? platformSignedAt = freezed,Object? buyerSignerName = freezed,Object? buyerSignerTitle = freezed,Object? buyerCompanyName = freezed,Object? sellerSignerName = freezed,Object? sellerSignerTitle = freezed,Object? sellerCompanyName = freezed,Object? platformSignerName = freezed,Object? platformSignerTitle = freezed,Object? isFullySigned = null,Object? requiredSigners = null,Object? signedCount = null,Object? signatures = null,Object? rejectionReason = freezed,Object? terminatedAt = freezed,Object? terminatedBy = freezed,Object? renewalCount = null,Object? renewalProposedEndDate = freezed,Object? renewalRequestedBy = freezed,Object? renewalRequestedAt = freezed,Object? renewalNote = freezed,Object? daysUntilExpiry = freezed,Object? contractPhase = freezed,Object? canRenew = null,Object? isRenewalPending = null,Object? createdAt = null,Object? updatedAt = null,Object? buyer = null,Object? supplier = null,}) {
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
as List<PartnershipSignatureModel>,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,terminatedAt: freezed == terminatedAt ? _self.terminatedAt : terminatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,terminatedBy: freezed == terminatedBy ? _self.terminatedBy : terminatedBy // ignore: cast_nullable_to_non_nullable
as String?,renewalCount: null == renewalCount ? _self.renewalCount : renewalCount // ignore: cast_nullable_to_non_nullable
as int,renewalProposedEndDate: freezed == renewalProposedEndDate ? _self.renewalProposedEndDate : renewalProposedEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,renewalRequestedBy: freezed == renewalRequestedBy ? _self.renewalRequestedBy : renewalRequestedBy // ignore: cast_nullable_to_non_nullable
as String?,renewalRequestedAt: freezed == renewalRequestedAt ? _self.renewalRequestedAt : renewalRequestedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,renewalNote: freezed == renewalNote ? _self.renewalNote : renewalNote // ignore: cast_nullable_to_non_nullable
as String?,daysUntilExpiry: freezed == daysUntilExpiry ? _self.daysUntilExpiry : daysUntilExpiry // ignore: cast_nullable_to_non_nullable
as int?,contractPhase: freezed == contractPhase ? _self.contractPhase : contractPhase // ignore: cast_nullable_to_non_nullable
as String?,canRenew: null == canRenew ? _self.canRenew : canRenew // ignore: cast_nullable_to_non_nullable
as bool,isRenewalPending: null == isRenewalPending ? _self.isRenewalPending : isRenewalPending // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,buyer: null == buyer ? _self.buyer : buyer // ignore: cast_nullable_to_non_nullable
as PartnershipUserModel,supplier: null == supplier ? _self.supplier : supplier // ignore: cast_nullable_to_non_nullable
as PartnershipUserModel,
  ));
}
/// Create a copy of PartnershipModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartnershipUserModelCopyWith<$Res> get buyer {
  
  return $PartnershipUserModelCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}/// Create a copy of PartnershipModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartnershipUserModelCopyWith<$Res> get supplier {
  
  return $PartnershipUserModelCopyWith<$Res>(_self.supplier, (value) {
    return _then(_self.copyWith(supplier: value));
  });
}
}


/// Adds pattern-matching-related methods to [PartnershipModel].
extension PartnershipModelPatterns on PartnershipModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartnershipModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartnershipModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartnershipModel value)  $default,){
final _that = this;
switch (_that) {
case _PartnershipModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartnershipModel value)?  $default,){
final _that = this;
switch (_that) {
case _PartnershipModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String contractNumber,  String buyerId,  String supplierId,  String tier,  String status,  String title,  String? description,  String? productCategory,  double? estimatedMonthlyQty,  String? priceAgreement,  String? deliveryTerms,  String? paymentTerms,  String? specialTerms,  DateTime startDate,  DateTime endDate,  DateTime? buyerSignedAt,  DateTime? sellerSignedAt,  DateTime? platformSignedAt,  String? buyerSignerName,  String? buyerSignerTitle,  String? buyerCompanyName,  String? sellerSignerName,  String? sellerSignerTitle,  String? sellerCompanyName,  String? platformSignerName,  String? platformSignerTitle,  bool isFullySigned,  int requiredSigners,  int signedCount,  List<PartnershipSignatureModel> signatures,  String? rejectionReason,  DateTime? terminatedAt,  String? terminatedBy,  int renewalCount,  DateTime? renewalProposedEndDate,  String? renewalRequestedBy,  DateTime? renewalRequestedAt,  String? renewalNote,  int? daysUntilExpiry,  String? contractPhase,  bool canRenew,  bool isRenewalPending,  DateTime createdAt,  DateTime updatedAt,  PartnershipUserModel buyer,  PartnershipUserModel supplier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartnershipModel() when $default != null:
return $default(_that.id,_that.contractNumber,_that.buyerId,_that.supplierId,_that.tier,_that.status,_that.title,_that.description,_that.productCategory,_that.estimatedMonthlyQty,_that.priceAgreement,_that.deliveryTerms,_that.paymentTerms,_that.specialTerms,_that.startDate,_that.endDate,_that.buyerSignedAt,_that.sellerSignedAt,_that.platformSignedAt,_that.buyerSignerName,_that.buyerSignerTitle,_that.buyerCompanyName,_that.sellerSignerName,_that.sellerSignerTitle,_that.sellerCompanyName,_that.platformSignerName,_that.platformSignerTitle,_that.isFullySigned,_that.requiredSigners,_that.signedCount,_that.signatures,_that.rejectionReason,_that.terminatedAt,_that.terminatedBy,_that.renewalCount,_that.renewalProposedEndDate,_that.renewalRequestedBy,_that.renewalRequestedAt,_that.renewalNote,_that.daysUntilExpiry,_that.contractPhase,_that.canRenew,_that.isRenewalPending,_that.createdAt,_that.updatedAt,_that.buyer,_that.supplier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String contractNumber,  String buyerId,  String supplierId,  String tier,  String status,  String title,  String? description,  String? productCategory,  double? estimatedMonthlyQty,  String? priceAgreement,  String? deliveryTerms,  String? paymentTerms,  String? specialTerms,  DateTime startDate,  DateTime endDate,  DateTime? buyerSignedAt,  DateTime? sellerSignedAt,  DateTime? platformSignedAt,  String? buyerSignerName,  String? buyerSignerTitle,  String? buyerCompanyName,  String? sellerSignerName,  String? sellerSignerTitle,  String? sellerCompanyName,  String? platformSignerName,  String? platformSignerTitle,  bool isFullySigned,  int requiredSigners,  int signedCount,  List<PartnershipSignatureModel> signatures,  String? rejectionReason,  DateTime? terminatedAt,  String? terminatedBy,  int renewalCount,  DateTime? renewalProposedEndDate,  String? renewalRequestedBy,  DateTime? renewalRequestedAt,  String? renewalNote,  int? daysUntilExpiry,  String? contractPhase,  bool canRenew,  bool isRenewalPending,  DateTime createdAt,  DateTime updatedAt,  PartnershipUserModel buyer,  PartnershipUserModel supplier)  $default,) {final _that = this;
switch (_that) {
case _PartnershipModel():
return $default(_that.id,_that.contractNumber,_that.buyerId,_that.supplierId,_that.tier,_that.status,_that.title,_that.description,_that.productCategory,_that.estimatedMonthlyQty,_that.priceAgreement,_that.deliveryTerms,_that.paymentTerms,_that.specialTerms,_that.startDate,_that.endDate,_that.buyerSignedAt,_that.sellerSignedAt,_that.platformSignedAt,_that.buyerSignerName,_that.buyerSignerTitle,_that.buyerCompanyName,_that.sellerSignerName,_that.sellerSignerTitle,_that.sellerCompanyName,_that.platformSignerName,_that.platformSignerTitle,_that.isFullySigned,_that.requiredSigners,_that.signedCount,_that.signatures,_that.rejectionReason,_that.terminatedAt,_that.terminatedBy,_that.renewalCount,_that.renewalProposedEndDate,_that.renewalRequestedBy,_that.renewalRequestedAt,_that.renewalNote,_that.daysUntilExpiry,_that.contractPhase,_that.canRenew,_that.isRenewalPending,_that.createdAt,_that.updatedAt,_that.buyer,_that.supplier);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String contractNumber,  String buyerId,  String supplierId,  String tier,  String status,  String title,  String? description,  String? productCategory,  double? estimatedMonthlyQty,  String? priceAgreement,  String? deliveryTerms,  String? paymentTerms,  String? specialTerms,  DateTime startDate,  DateTime endDate,  DateTime? buyerSignedAt,  DateTime? sellerSignedAt,  DateTime? platformSignedAt,  String? buyerSignerName,  String? buyerSignerTitle,  String? buyerCompanyName,  String? sellerSignerName,  String? sellerSignerTitle,  String? sellerCompanyName,  String? platformSignerName,  String? platformSignerTitle,  bool isFullySigned,  int requiredSigners,  int signedCount,  List<PartnershipSignatureModel> signatures,  String? rejectionReason,  DateTime? terminatedAt,  String? terminatedBy,  int renewalCount,  DateTime? renewalProposedEndDate,  String? renewalRequestedBy,  DateTime? renewalRequestedAt,  String? renewalNote,  int? daysUntilExpiry,  String? contractPhase,  bool canRenew,  bool isRenewalPending,  DateTime createdAt,  DateTime updatedAt,  PartnershipUserModel buyer,  PartnershipUserModel supplier)?  $default,) {final _that = this;
switch (_that) {
case _PartnershipModel() when $default != null:
return $default(_that.id,_that.contractNumber,_that.buyerId,_that.supplierId,_that.tier,_that.status,_that.title,_that.description,_that.productCategory,_that.estimatedMonthlyQty,_that.priceAgreement,_that.deliveryTerms,_that.paymentTerms,_that.specialTerms,_that.startDate,_that.endDate,_that.buyerSignedAt,_that.sellerSignedAt,_that.platformSignedAt,_that.buyerSignerName,_that.buyerSignerTitle,_that.buyerCompanyName,_that.sellerSignerName,_that.sellerSignerTitle,_that.sellerCompanyName,_that.platformSignerName,_that.platformSignerTitle,_that.isFullySigned,_that.requiredSigners,_that.signedCount,_that.signatures,_that.rejectionReason,_that.terminatedAt,_that.terminatedBy,_that.renewalCount,_that.renewalProposedEndDate,_that.renewalRequestedBy,_that.renewalRequestedAt,_that.renewalNote,_that.daysUntilExpiry,_that.contractPhase,_that.canRenew,_that.isRenewalPending,_that.createdAt,_that.updatedAt,_that.buyer,_that.supplier);case _:
  return null;

}
}

}

/// @nodoc


class _PartnershipModel implements PartnershipModel {
  const _PartnershipModel({required this.id, required this.contractNumber, required this.buyerId, required this.supplierId, required this.tier, required this.status, required this.title, this.description, this.productCategory, this.estimatedMonthlyQty, this.priceAgreement, this.deliveryTerms, this.paymentTerms, this.specialTerms, required this.startDate, required this.endDate, this.buyerSignedAt, this.sellerSignedAt, this.platformSignedAt, this.buyerSignerName, this.buyerSignerTitle, this.buyerCompanyName, this.sellerSignerName, this.sellerSignerTitle, this.sellerCompanyName, this.platformSignerName, this.platformSignerTitle, this.isFullySigned = false, this.requiredSigners = 3, this.signedCount = 0, final  List<PartnershipSignatureModel> signatures = const [], this.rejectionReason, this.terminatedAt, this.terminatedBy, this.renewalCount = 0, this.renewalProposedEndDate, this.renewalRequestedBy, this.renewalRequestedAt, this.renewalNote, this.daysUntilExpiry, this.contractPhase, this.canRenew = false, this.isRenewalPending = false, required this.createdAt, required this.updatedAt, required this.buyer, required this.supplier}): _signatures = signatures;
  

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
 final  List<PartnershipSignatureModel> _signatures;
@override@JsonKey() List<PartnershipSignatureModel> get signatures {
  if (_signatures is EqualUnmodifiableListView) return _signatures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_signatures);
}

@override final  String? rejectionReason;
@override final  DateTime? terminatedAt;
@override final  String? terminatedBy;
@override@JsonKey() final  int renewalCount;
@override final  DateTime? renewalProposedEndDate;
@override final  String? renewalRequestedBy;
@override final  DateTime? renewalRequestedAt;
@override final  String? renewalNote;
@override final  int? daysUntilExpiry;
@override final  String? contractPhase;
@override@JsonKey() final  bool canRenew;
@override@JsonKey() final  bool isRenewalPending;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  PartnershipUserModel buyer;
@override final  PartnershipUserModel supplier;

/// Create a copy of PartnershipModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartnershipModelCopyWith<_PartnershipModel> get copyWith => __$PartnershipModelCopyWithImpl<_PartnershipModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartnershipModel&&(identical(other.id, id) || other.id == id)&&(identical(other.contractNumber, contractNumber) || other.contractNumber == contractNumber)&&(identical(other.buyerId, buyerId) || other.buyerId == buyerId)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.status, status) || other.status == status)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.productCategory, productCategory) || other.productCategory == productCategory)&&(identical(other.estimatedMonthlyQty, estimatedMonthlyQty) || other.estimatedMonthlyQty == estimatedMonthlyQty)&&(identical(other.priceAgreement, priceAgreement) || other.priceAgreement == priceAgreement)&&(identical(other.deliveryTerms, deliveryTerms) || other.deliveryTerms == deliveryTerms)&&(identical(other.paymentTerms, paymentTerms) || other.paymentTerms == paymentTerms)&&(identical(other.specialTerms, specialTerms) || other.specialTerms == specialTerms)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.buyerSignedAt, buyerSignedAt) || other.buyerSignedAt == buyerSignedAt)&&(identical(other.sellerSignedAt, sellerSignedAt) || other.sellerSignedAt == sellerSignedAt)&&(identical(other.platformSignedAt, platformSignedAt) || other.platformSignedAt == platformSignedAt)&&(identical(other.buyerSignerName, buyerSignerName) || other.buyerSignerName == buyerSignerName)&&(identical(other.buyerSignerTitle, buyerSignerTitle) || other.buyerSignerTitle == buyerSignerTitle)&&(identical(other.buyerCompanyName, buyerCompanyName) || other.buyerCompanyName == buyerCompanyName)&&(identical(other.sellerSignerName, sellerSignerName) || other.sellerSignerName == sellerSignerName)&&(identical(other.sellerSignerTitle, sellerSignerTitle) || other.sellerSignerTitle == sellerSignerTitle)&&(identical(other.sellerCompanyName, sellerCompanyName) || other.sellerCompanyName == sellerCompanyName)&&(identical(other.platformSignerName, platformSignerName) || other.platformSignerName == platformSignerName)&&(identical(other.platformSignerTitle, platformSignerTitle) || other.platformSignerTitle == platformSignerTitle)&&(identical(other.isFullySigned, isFullySigned) || other.isFullySigned == isFullySigned)&&(identical(other.requiredSigners, requiredSigners) || other.requiredSigners == requiredSigners)&&(identical(other.signedCount, signedCount) || other.signedCount == signedCount)&&const DeepCollectionEquality().equals(other._signatures, _signatures)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.terminatedAt, terminatedAt) || other.terminatedAt == terminatedAt)&&(identical(other.terminatedBy, terminatedBy) || other.terminatedBy == terminatedBy)&&(identical(other.renewalCount, renewalCount) || other.renewalCount == renewalCount)&&(identical(other.renewalProposedEndDate, renewalProposedEndDate) || other.renewalProposedEndDate == renewalProposedEndDate)&&(identical(other.renewalRequestedBy, renewalRequestedBy) || other.renewalRequestedBy == renewalRequestedBy)&&(identical(other.renewalRequestedAt, renewalRequestedAt) || other.renewalRequestedAt == renewalRequestedAt)&&(identical(other.renewalNote, renewalNote) || other.renewalNote == renewalNote)&&(identical(other.daysUntilExpiry, daysUntilExpiry) || other.daysUntilExpiry == daysUntilExpiry)&&(identical(other.contractPhase, contractPhase) || other.contractPhase == contractPhase)&&(identical(other.canRenew, canRenew) || other.canRenew == canRenew)&&(identical(other.isRenewalPending, isRenewalPending) || other.isRenewalPending == isRenewalPending)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&(identical(other.supplier, supplier) || other.supplier == supplier));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,contractNumber,buyerId,supplierId,tier,status,title,description,productCategory,estimatedMonthlyQty,priceAgreement,deliveryTerms,paymentTerms,specialTerms,startDate,endDate,buyerSignedAt,sellerSignedAt,platformSignedAt,buyerSignerName,buyerSignerTitle,buyerCompanyName,sellerSignerName,sellerSignerTitle,sellerCompanyName,platformSignerName,platformSignerTitle,isFullySigned,requiredSigners,signedCount,const DeepCollectionEquality().hash(_signatures),rejectionReason,terminatedAt,terminatedBy,renewalCount,renewalProposedEndDate,renewalRequestedBy,renewalRequestedAt,renewalNote,daysUntilExpiry,contractPhase,canRenew,isRenewalPending,createdAt,updatedAt,buyer,supplier]);

@override
String toString() {
  return 'PartnershipModel(id: $id, contractNumber: $contractNumber, buyerId: $buyerId, supplierId: $supplierId, tier: $tier, status: $status, title: $title, description: $description, productCategory: $productCategory, estimatedMonthlyQty: $estimatedMonthlyQty, priceAgreement: $priceAgreement, deliveryTerms: $deliveryTerms, paymentTerms: $paymentTerms, specialTerms: $specialTerms, startDate: $startDate, endDate: $endDate, buyerSignedAt: $buyerSignedAt, sellerSignedAt: $sellerSignedAt, platformSignedAt: $platformSignedAt, buyerSignerName: $buyerSignerName, buyerSignerTitle: $buyerSignerTitle, buyerCompanyName: $buyerCompanyName, sellerSignerName: $sellerSignerName, sellerSignerTitle: $sellerSignerTitle, sellerCompanyName: $sellerCompanyName, platformSignerName: $platformSignerName, platformSignerTitle: $platformSignerTitle, isFullySigned: $isFullySigned, requiredSigners: $requiredSigners, signedCount: $signedCount, signatures: $signatures, rejectionReason: $rejectionReason, terminatedAt: $terminatedAt, terminatedBy: $terminatedBy, renewalCount: $renewalCount, renewalProposedEndDate: $renewalProposedEndDate, renewalRequestedBy: $renewalRequestedBy, renewalRequestedAt: $renewalRequestedAt, renewalNote: $renewalNote, daysUntilExpiry: $daysUntilExpiry, contractPhase: $contractPhase, canRenew: $canRenew, isRenewalPending: $isRenewalPending, createdAt: $createdAt, updatedAt: $updatedAt, buyer: $buyer, supplier: $supplier)';
}


}

/// @nodoc
abstract mixin class _$PartnershipModelCopyWith<$Res> implements $PartnershipModelCopyWith<$Res> {
  factory _$PartnershipModelCopyWith(_PartnershipModel value, $Res Function(_PartnershipModel) _then) = __$PartnershipModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String contractNumber, String buyerId, String supplierId, String tier, String status, String title, String? description, String? productCategory, double? estimatedMonthlyQty, String? priceAgreement, String? deliveryTerms, String? paymentTerms, String? specialTerms, DateTime startDate, DateTime endDate, DateTime? buyerSignedAt, DateTime? sellerSignedAt, DateTime? platformSignedAt, String? buyerSignerName, String? buyerSignerTitle, String? buyerCompanyName, String? sellerSignerName, String? sellerSignerTitle, String? sellerCompanyName, String? platformSignerName, String? platformSignerTitle, bool isFullySigned, int requiredSigners, int signedCount, List<PartnershipSignatureModel> signatures, String? rejectionReason, DateTime? terminatedAt, String? terminatedBy, int renewalCount, DateTime? renewalProposedEndDate, String? renewalRequestedBy, DateTime? renewalRequestedAt, String? renewalNote, int? daysUntilExpiry, String? contractPhase, bool canRenew, bool isRenewalPending, DateTime createdAt, DateTime updatedAt, PartnershipUserModel buyer, PartnershipUserModel supplier
});


@override $PartnershipUserModelCopyWith<$Res> get buyer;@override $PartnershipUserModelCopyWith<$Res> get supplier;

}
/// @nodoc
class __$PartnershipModelCopyWithImpl<$Res>
    implements _$PartnershipModelCopyWith<$Res> {
  __$PartnershipModelCopyWithImpl(this._self, this._then);

  final _PartnershipModel _self;
  final $Res Function(_PartnershipModel) _then;

/// Create a copy of PartnershipModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? contractNumber = null,Object? buyerId = null,Object? supplierId = null,Object? tier = null,Object? status = null,Object? title = null,Object? description = freezed,Object? productCategory = freezed,Object? estimatedMonthlyQty = freezed,Object? priceAgreement = freezed,Object? deliveryTerms = freezed,Object? paymentTerms = freezed,Object? specialTerms = freezed,Object? startDate = null,Object? endDate = null,Object? buyerSignedAt = freezed,Object? sellerSignedAt = freezed,Object? platformSignedAt = freezed,Object? buyerSignerName = freezed,Object? buyerSignerTitle = freezed,Object? buyerCompanyName = freezed,Object? sellerSignerName = freezed,Object? sellerSignerTitle = freezed,Object? sellerCompanyName = freezed,Object? platformSignerName = freezed,Object? platformSignerTitle = freezed,Object? isFullySigned = null,Object? requiredSigners = null,Object? signedCount = null,Object? signatures = null,Object? rejectionReason = freezed,Object? terminatedAt = freezed,Object? terminatedBy = freezed,Object? renewalCount = null,Object? renewalProposedEndDate = freezed,Object? renewalRequestedBy = freezed,Object? renewalRequestedAt = freezed,Object? renewalNote = freezed,Object? daysUntilExpiry = freezed,Object? contractPhase = freezed,Object? canRenew = null,Object? isRenewalPending = null,Object? createdAt = null,Object? updatedAt = null,Object? buyer = null,Object? supplier = null,}) {
  return _then(_PartnershipModel(
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
as List<PartnershipSignatureModel>,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,terminatedAt: freezed == terminatedAt ? _self.terminatedAt : terminatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,terminatedBy: freezed == terminatedBy ? _self.terminatedBy : terminatedBy // ignore: cast_nullable_to_non_nullable
as String?,renewalCount: null == renewalCount ? _self.renewalCount : renewalCount // ignore: cast_nullable_to_non_nullable
as int,renewalProposedEndDate: freezed == renewalProposedEndDate ? _self.renewalProposedEndDate : renewalProposedEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,renewalRequestedBy: freezed == renewalRequestedBy ? _self.renewalRequestedBy : renewalRequestedBy // ignore: cast_nullable_to_non_nullable
as String?,renewalRequestedAt: freezed == renewalRequestedAt ? _self.renewalRequestedAt : renewalRequestedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,renewalNote: freezed == renewalNote ? _self.renewalNote : renewalNote // ignore: cast_nullable_to_non_nullable
as String?,daysUntilExpiry: freezed == daysUntilExpiry ? _self.daysUntilExpiry : daysUntilExpiry // ignore: cast_nullable_to_non_nullable
as int?,contractPhase: freezed == contractPhase ? _self.contractPhase : contractPhase // ignore: cast_nullable_to_non_nullable
as String?,canRenew: null == canRenew ? _self.canRenew : canRenew // ignore: cast_nullable_to_non_nullable
as bool,isRenewalPending: null == isRenewalPending ? _self.isRenewalPending : isRenewalPending // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,buyer: null == buyer ? _self.buyer : buyer // ignore: cast_nullable_to_non_nullable
as PartnershipUserModel,supplier: null == supplier ? _self.supplier : supplier // ignore: cast_nullable_to_non_nullable
as PartnershipUserModel,
  ));
}

/// Create a copy of PartnershipModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartnershipUserModelCopyWith<$Res> get buyer {
  
  return $PartnershipUserModelCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}/// Create a copy of PartnershipModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartnershipUserModelCopyWith<$Res> get supplier {
  
  return $PartnershipUserModelCopyWith<$Res>(_self.supplier, (value) {
    return _then(_self.copyWith(supplier: value));
  });
}
}

/// @nodoc
mixin _$PartnershipListModel {

 List<PartnershipModel> get partnerships; int get total; int get page; int get limit;
/// Create a copy of PartnershipListModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartnershipListModelCopyWith<PartnershipListModel> get copyWith => _$PartnershipListModelCopyWithImpl<PartnershipListModel>(this as PartnershipListModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartnershipListModel&&const DeepCollectionEquality().equals(other.partnerships, partnerships)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(partnerships),total,page,limit);

@override
String toString() {
  return 'PartnershipListModel(partnerships: $partnerships, total: $total, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $PartnershipListModelCopyWith<$Res>  {
  factory $PartnershipListModelCopyWith(PartnershipListModel value, $Res Function(PartnershipListModel) _then) = _$PartnershipListModelCopyWithImpl;
@useResult
$Res call({
 List<PartnershipModel> partnerships, int total, int page, int limit
});




}
/// @nodoc
class _$PartnershipListModelCopyWithImpl<$Res>
    implements $PartnershipListModelCopyWith<$Res> {
  _$PartnershipListModelCopyWithImpl(this._self, this._then);

  final PartnershipListModel _self;
  final $Res Function(PartnershipListModel) _then;

/// Create a copy of PartnershipListModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? partnerships = null,Object? total = null,Object? page = null,Object? limit = null,}) {
  return _then(_self.copyWith(
partnerships: null == partnerships ? _self.partnerships : partnerships // ignore: cast_nullable_to_non_nullable
as List<PartnershipModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PartnershipListModel].
extension PartnershipListModelPatterns on PartnershipListModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartnershipListModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartnershipListModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartnershipListModel value)  $default,){
final _that = this;
switch (_that) {
case _PartnershipListModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartnershipListModel value)?  $default,){
final _that = this;
switch (_that) {
case _PartnershipListModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PartnershipModel> partnerships,  int total,  int page,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartnershipListModel() when $default != null:
return $default(_that.partnerships,_that.total,_that.page,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PartnershipModel> partnerships,  int total,  int page,  int limit)  $default,) {final _that = this;
switch (_that) {
case _PartnershipListModel():
return $default(_that.partnerships,_that.total,_that.page,_that.limit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PartnershipModel> partnerships,  int total,  int page,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _PartnershipListModel() when $default != null:
return $default(_that.partnerships,_that.total,_that.page,_that.limit);case _:
  return null;

}
}

}

/// @nodoc


class _PartnershipListModel implements PartnershipListModel {
  const _PartnershipListModel({required final  List<PartnershipModel> partnerships, required this.total, required this.page, required this.limit}): _partnerships = partnerships;
  

 final  List<PartnershipModel> _partnerships;
@override List<PartnershipModel> get partnerships {
  if (_partnerships is EqualUnmodifiableListView) return _partnerships;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_partnerships);
}

@override final  int total;
@override final  int page;
@override final  int limit;

/// Create a copy of PartnershipListModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartnershipListModelCopyWith<_PartnershipListModel> get copyWith => __$PartnershipListModelCopyWithImpl<_PartnershipListModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartnershipListModel&&const DeepCollectionEquality().equals(other._partnerships, _partnerships)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_partnerships),total,page,limit);

@override
String toString() {
  return 'PartnershipListModel(partnerships: $partnerships, total: $total, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$PartnershipListModelCopyWith<$Res> implements $PartnershipListModelCopyWith<$Res> {
  factory _$PartnershipListModelCopyWith(_PartnershipListModel value, $Res Function(_PartnershipListModel) _then) = __$PartnershipListModelCopyWithImpl;
@override @useResult
$Res call({
 List<PartnershipModel> partnerships, int total, int page, int limit
});




}
/// @nodoc
class __$PartnershipListModelCopyWithImpl<$Res>
    implements _$PartnershipListModelCopyWith<$Res> {
  __$PartnershipListModelCopyWithImpl(this._self, this._then);

  final _PartnershipListModel _self;
  final $Res Function(_PartnershipListModel) _then;

/// Create a copy of PartnershipListModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? partnerships = null,Object? total = null,Object? page = null,Object? limit = null,}) {
  return _then(_PartnershipListModel(
partnerships: null == partnerships ? _self._partnerships : partnerships // ignore: cast_nullable_to_non_nullable
as List<PartnershipModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$PartnershipCheckModel {

 bool get hasPartnership; PartnershipModel? get partnership; bool get canCreateNew; bool get canRenew;
/// Create a copy of PartnershipCheckModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartnershipCheckModelCopyWith<PartnershipCheckModel> get copyWith => _$PartnershipCheckModelCopyWithImpl<PartnershipCheckModel>(this as PartnershipCheckModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartnershipCheckModel&&(identical(other.hasPartnership, hasPartnership) || other.hasPartnership == hasPartnership)&&(identical(other.partnership, partnership) || other.partnership == partnership)&&(identical(other.canCreateNew, canCreateNew) || other.canCreateNew == canCreateNew)&&(identical(other.canRenew, canRenew) || other.canRenew == canRenew));
}


@override
int get hashCode => Object.hash(runtimeType,hasPartnership,partnership,canCreateNew,canRenew);

@override
String toString() {
  return 'PartnershipCheckModel(hasPartnership: $hasPartnership, partnership: $partnership, canCreateNew: $canCreateNew, canRenew: $canRenew)';
}


}

/// @nodoc
abstract mixin class $PartnershipCheckModelCopyWith<$Res>  {
  factory $PartnershipCheckModelCopyWith(PartnershipCheckModel value, $Res Function(PartnershipCheckModel) _then) = _$PartnershipCheckModelCopyWithImpl;
@useResult
$Res call({
 bool hasPartnership, PartnershipModel? partnership, bool canCreateNew, bool canRenew
});


$PartnershipModelCopyWith<$Res>? get partnership;

}
/// @nodoc
class _$PartnershipCheckModelCopyWithImpl<$Res>
    implements $PartnershipCheckModelCopyWith<$Res> {
  _$PartnershipCheckModelCopyWithImpl(this._self, this._then);

  final PartnershipCheckModel _self;
  final $Res Function(PartnershipCheckModel) _then;

/// Create a copy of PartnershipCheckModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasPartnership = null,Object? partnership = freezed,Object? canCreateNew = null,Object? canRenew = null,}) {
  return _then(_self.copyWith(
hasPartnership: null == hasPartnership ? _self.hasPartnership : hasPartnership // ignore: cast_nullable_to_non_nullable
as bool,partnership: freezed == partnership ? _self.partnership : partnership // ignore: cast_nullable_to_non_nullable
as PartnershipModel?,canCreateNew: null == canCreateNew ? _self.canCreateNew : canCreateNew // ignore: cast_nullable_to_non_nullable
as bool,canRenew: null == canRenew ? _self.canRenew : canRenew // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of PartnershipCheckModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartnershipModelCopyWith<$Res>? get partnership {
    if (_self.partnership == null) {
    return null;
  }

  return $PartnershipModelCopyWith<$Res>(_self.partnership!, (value) {
    return _then(_self.copyWith(partnership: value));
  });
}
}


/// Adds pattern-matching-related methods to [PartnershipCheckModel].
extension PartnershipCheckModelPatterns on PartnershipCheckModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartnershipCheckModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartnershipCheckModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartnershipCheckModel value)  $default,){
final _that = this;
switch (_that) {
case _PartnershipCheckModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartnershipCheckModel value)?  $default,){
final _that = this;
switch (_that) {
case _PartnershipCheckModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool hasPartnership,  PartnershipModel? partnership,  bool canCreateNew,  bool canRenew)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartnershipCheckModel() when $default != null:
return $default(_that.hasPartnership,_that.partnership,_that.canCreateNew,_that.canRenew);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool hasPartnership,  PartnershipModel? partnership,  bool canCreateNew,  bool canRenew)  $default,) {final _that = this;
switch (_that) {
case _PartnershipCheckModel():
return $default(_that.hasPartnership,_that.partnership,_that.canCreateNew,_that.canRenew);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool hasPartnership,  PartnershipModel? partnership,  bool canCreateNew,  bool canRenew)?  $default,) {final _that = this;
switch (_that) {
case _PartnershipCheckModel() when $default != null:
return $default(_that.hasPartnership,_that.partnership,_that.canCreateNew,_that.canRenew);case _:
  return null;

}
}

}

/// @nodoc


class _PartnershipCheckModel implements PartnershipCheckModel {
  const _PartnershipCheckModel({required this.hasPartnership, this.partnership, this.canCreateNew = true, this.canRenew = false});
  

@override final  bool hasPartnership;
@override final  PartnershipModel? partnership;
@override@JsonKey() final  bool canCreateNew;
@override@JsonKey() final  bool canRenew;

/// Create a copy of PartnershipCheckModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartnershipCheckModelCopyWith<_PartnershipCheckModel> get copyWith => __$PartnershipCheckModelCopyWithImpl<_PartnershipCheckModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartnershipCheckModel&&(identical(other.hasPartnership, hasPartnership) || other.hasPartnership == hasPartnership)&&(identical(other.partnership, partnership) || other.partnership == partnership)&&(identical(other.canCreateNew, canCreateNew) || other.canCreateNew == canCreateNew)&&(identical(other.canRenew, canRenew) || other.canRenew == canRenew));
}


@override
int get hashCode => Object.hash(runtimeType,hasPartnership,partnership,canCreateNew,canRenew);

@override
String toString() {
  return 'PartnershipCheckModel(hasPartnership: $hasPartnership, partnership: $partnership, canCreateNew: $canCreateNew, canRenew: $canRenew)';
}


}

/// @nodoc
abstract mixin class _$PartnershipCheckModelCopyWith<$Res> implements $PartnershipCheckModelCopyWith<$Res> {
  factory _$PartnershipCheckModelCopyWith(_PartnershipCheckModel value, $Res Function(_PartnershipCheckModel) _then) = __$PartnershipCheckModelCopyWithImpl;
@override @useResult
$Res call({
 bool hasPartnership, PartnershipModel? partnership, bool canCreateNew, bool canRenew
});


@override $PartnershipModelCopyWith<$Res>? get partnership;

}
/// @nodoc
class __$PartnershipCheckModelCopyWithImpl<$Res>
    implements _$PartnershipCheckModelCopyWith<$Res> {
  __$PartnershipCheckModelCopyWithImpl(this._self, this._then);

  final _PartnershipCheckModel _self;
  final $Res Function(_PartnershipCheckModel) _then;

/// Create a copy of PartnershipCheckModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasPartnership = null,Object? partnership = freezed,Object? canCreateNew = null,Object? canRenew = null,}) {
  return _then(_PartnershipCheckModel(
hasPartnership: null == hasPartnership ? _self.hasPartnership : hasPartnership // ignore: cast_nullable_to_non_nullable
as bool,partnership: freezed == partnership ? _self.partnership : partnership // ignore: cast_nullable_to_non_nullable
as PartnershipModel?,canCreateNew: null == canCreateNew ? _self.canCreateNew : canCreateNew // ignore: cast_nullable_to_non_nullable
as bool,canRenew: null == canRenew ? _self.canRenew : canRenew // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of PartnershipCheckModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartnershipModelCopyWith<$Res>? get partnership {
    if (_self.partnership == null) {
    return null;
  }

  return $PartnershipModelCopyWith<$Res>(_self.partnership!, (value) {
    return _then(_self.copyWith(partnership: value));
  });
}
}

// dart format on
