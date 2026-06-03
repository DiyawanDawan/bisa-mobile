// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supplier_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupplierModel {

 String get id; String get name; String? get avatar; String? get phone; String? get address; String? get province; String? get regency; bool get isVerified; double get rating; int get totalProducts;
/// Create a copy of SupplierModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupplierModelCopyWith<SupplierModel> get copyWith => _$SupplierModelCopyWithImpl<SupplierModel>(this as SupplierModel, _$identity);

  /// Serializes this SupplierModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupplierModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalProducts, totalProducts) || other.totalProducts == totalProducts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatar,phone,address,province,regency,isVerified,rating,totalProducts);

@override
String toString() {
  return 'SupplierModel(id: $id, name: $name, avatar: $avatar, phone: $phone, address: $address, province: $province, regency: $regency, isVerified: $isVerified, rating: $rating, totalProducts: $totalProducts)';
}


}

/// @nodoc
abstract mixin class $SupplierModelCopyWith<$Res>  {
  factory $SupplierModelCopyWith(SupplierModel value, $Res Function(SupplierModel) _then) = _$SupplierModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? avatar, String? phone, String? address, String? province, String? regency, bool isVerified, double rating, int totalProducts
});




}
/// @nodoc
class _$SupplierModelCopyWithImpl<$Res>
    implements $SupplierModelCopyWith<$Res> {
  _$SupplierModelCopyWithImpl(this._self, this._then);

  final SupplierModel _self;
  final $Res Function(SupplierModel) _then;

/// Create a copy of SupplierModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? avatar = freezed,Object? phone = freezed,Object? address = freezed,Object? province = freezed,Object? regency = freezed,Object? isVerified = null,Object? rating = null,Object? totalProducts = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalProducts: null == totalProducts ? _self.totalProducts : totalProducts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SupplierModel].
extension SupplierModelPatterns on SupplierModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupplierModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupplierModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupplierModel value)  $default,){
final _that = this;
switch (_that) {
case _SupplierModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupplierModel value)?  $default,){
final _that = this;
switch (_that) {
case _SupplierModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? avatar,  String? phone,  String? address,  String? province,  String? regency,  bool isVerified,  double rating,  int totalProducts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupplierModel() when $default != null:
return $default(_that.id,_that.name,_that.avatar,_that.phone,_that.address,_that.province,_that.regency,_that.isVerified,_that.rating,_that.totalProducts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? avatar,  String? phone,  String? address,  String? province,  String? regency,  bool isVerified,  double rating,  int totalProducts)  $default,) {final _that = this;
switch (_that) {
case _SupplierModel():
return $default(_that.id,_that.name,_that.avatar,_that.phone,_that.address,_that.province,_that.regency,_that.isVerified,_that.rating,_that.totalProducts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? avatar,  String? phone,  String? address,  String? province,  String? regency,  bool isVerified,  double rating,  int totalProducts)?  $default,) {final _that = this;
switch (_that) {
case _SupplierModel() when $default != null:
return $default(_that.id,_that.name,_that.avatar,_that.phone,_that.address,_that.province,_that.regency,_that.isVerified,_that.rating,_that.totalProducts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupplierModel implements SupplierModel {
  const _SupplierModel({required this.id, required this.name, this.avatar, this.phone, this.address, this.province, this.regency, this.isVerified = false, this.rating = 0.0, this.totalProducts = 0});
  factory _SupplierModel.fromJson(Map<String, dynamic> json) => _$SupplierModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? avatar;
@override final  String? phone;
@override final  String? address;
@override final  String? province;
@override final  String? regency;
@override@JsonKey() final  bool isVerified;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int totalProducts;

/// Create a copy of SupplierModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupplierModelCopyWith<_SupplierModel> get copyWith => __$SupplierModelCopyWithImpl<_SupplierModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupplierModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupplierModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalProducts, totalProducts) || other.totalProducts == totalProducts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatar,phone,address,province,regency,isVerified,rating,totalProducts);

@override
String toString() {
  return 'SupplierModel(id: $id, name: $name, avatar: $avatar, phone: $phone, address: $address, province: $province, regency: $regency, isVerified: $isVerified, rating: $rating, totalProducts: $totalProducts)';
}


}

/// @nodoc
abstract mixin class _$SupplierModelCopyWith<$Res> implements $SupplierModelCopyWith<$Res> {
  factory _$SupplierModelCopyWith(_SupplierModel value, $Res Function(_SupplierModel) _then) = __$SupplierModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? avatar, String? phone, String? address, String? province, String? regency, bool isVerified, double rating, int totalProducts
});




}
/// @nodoc
class __$SupplierModelCopyWithImpl<$Res>
    implements _$SupplierModelCopyWith<$Res> {
  __$SupplierModelCopyWithImpl(this._self, this._then);

  final _SupplierModel _self;
  final $Res Function(_SupplierModel) _then;

/// Create a copy of SupplierModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? avatar = freezed,Object? phone = freezed,Object? address = freezed,Object? province = freezed,Object? regency = freezed,Object? isVerified = null,Object? rating = null,Object? totalProducts = null,}) {
  return _then(_SupplierModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalProducts: null == totalProducts ? _self.totalProducts : totalProducts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
