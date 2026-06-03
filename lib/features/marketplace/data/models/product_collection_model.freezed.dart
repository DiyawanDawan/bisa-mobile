// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_collection_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductCollectionModel {

 String get id; String get name; String get slug; String? get description; String? get thumbnailUrl; bool get isActive;
/// Create a copy of ProductCollectionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCollectionModelCopyWith<ProductCollectionModel> get copyWith => _$ProductCollectionModelCopyWithImpl<ProductCollectionModel>(this as ProductCollectionModel, _$identity);

  /// Serializes this ProductCollectionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductCollectionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,description,thumbnailUrl,isActive);

@override
String toString() {
  return 'ProductCollectionModel(id: $id, name: $name, slug: $slug, description: $description, thumbnailUrl: $thumbnailUrl, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $ProductCollectionModelCopyWith<$Res>  {
  factory $ProductCollectionModelCopyWith(ProductCollectionModel value, $Res Function(ProductCollectionModel) _then) = _$ProductCollectionModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String slug, String? description, String? thumbnailUrl, bool isActive
});




}
/// @nodoc
class _$ProductCollectionModelCopyWithImpl<$Res>
    implements $ProductCollectionModelCopyWith<$Res> {
  _$ProductCollectionModelCopyWithImpl(this._self, this._then);

  final ProductCollectionModel _self;
  final $Res Function(ProductCollectionModel) _then;

/// Create a copy of ProductCollectionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? description = freezed,Object? thumbnailUrl = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductCollectionModel].
extension ProductCollectionModelPatterns on ProductCollectionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductCollectionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductCollectionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductCollectionModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductCollectionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductCollectionModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductCollectionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String? description,  String? thumbnailUrl,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductCollectionModel() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.description,_that.thumbnailUrl,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String? description,  String? thumbnailUrl,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _ProductCollectionModel():
return $default(_that.id,_that.name,_that.slug,_that.description,_that.thumbnailUrl,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String slug,  String? description,  String? thumbnailUrl,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _ProductCollectionModel() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.description,_that.thumbnailUrl,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductCollectionModel extends ProductCollectionModel {
  const _ProductCollectionModel({required this.id, required this.name, required this.slug, this.description, this.thumbnailUrl, this.isActive = true}): super._();
  factory _ProductCollectionModel.fromJson(Map<String, dynamic> json) => _$ProductCollectionModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String slug;
@override final  String? description;
@override final  String? thumbnailUrl;
@override@JsonKey() final  bool isActive;

/// Create a copy of ProductCollectionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCollectionModelCopyWith<_ProductCollectionModel> get copyWith => __$ProductCollectionModelCopyWithImpl<_ProductCollectionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductCollectionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductCollectionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,description,thumbnailUrl,isActive);

@override
String toString() {
  return 'ProductCollectionModel(id: $id, name: $name, slug: $slug, description: $description, thumbnailUrl: $thumbnailUrl, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ProductCollectionModelCopyWith<$Res> implements $ProductCollectionModelCopyWith<$Res> {
  factory _$ProductCollectionModelCopyWith(_ProductCollectionModel value, $Res Function(_ProductCollectionModel) _then) = __$ProductCollectionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String slug, String? description, String? thumbnailUrl, bool isActive
});




}
/// @nodoc
class __$ProductCollectionModelCopyWithImpl<$Res>
    implements _$ProductCollectionModelCopyWith<$Res> {
  __$ProductCollectionModelCopyWithImpl(this._self, this._then);

  final _ProductCollectionModel _self;
  final $Res Function(_ProductCollectionModel) _then;

/// Create a copy of ProductCollectionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? description = freezed,Object? thumbnailUrl = freezed,Object? isActive = null,}) {
  return _then(_ProductCollectionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
